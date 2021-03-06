pipeline {
  agent any
  stages {


      
    stage('CHECK') {
      steps {
           dir('deploy') {
        sh 'echo "TEST PIPELINE"'
        sh '''
                 echo "Multiline shell step to work"
                 ls -alh
                 whoami
                 '''
      
      }
    }}
    stage('Upload CFN Template') {
      steps {
           dir('deploy') {
        sh 'echo "TEST PIPELINE"'
        sh '''
                cd roles/cloudformation/files/
                aws --region us-east-2 cloudformation package \
                --template-file eks-root.json --output-template /tmp/packed-eks-stacks.json \
                --s3-bucket mkallali-eks-cfn-us-east-2 --use-json
                 '''
      }
      }
    }

 stage('Create Infra') {
           steps {
                dir('deploy') {
        sh 'echo "DEPLOY CFN "'
        sh '''
                pwd
                ansible-playbook eks-cluster.yml
            '''
      }
      }

 }


  stage('Lint Dockerfile') {
            steps {
                script {
                    docker.image('hadolint/hadolint:latest-debian').inside() {
                            sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
                            sh '''
                                lintErrors=$(stat --printf="%s"  hadolint_lint.txt)
                                if [ "$lintErrors" -gt "0" ]; then
                                    echo "Errors have been found, please see below"
                                    cat hadolint_lint.txt
                                    exit 1
                                else
                                    echo "There are no erros found on Dockerfile!!"
                                fi
                            '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
              steps {
                  sh 'docker build --tag go-graphql-app .'
              }
         }
        //  stage('Security Scan') {
        //       steps { 
        //          aquaMicrosca
        //          nner imageName: 'graphql:latest', notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
        //       }
        //  }
         stage('Push Docker Image') {
              steps {
                  withDockerRegistry([url: "", credentialsId: "docker-reg"]) {
                      sh "docker tag go-graphql-app mkallali/go-graphql-app"
                      sh 'docker push mkallali/go-graphql-app'
                  }
              }
         }
         stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'aws-static', region: 'us-east-2') {
                      sh "aws --region us-east-2 eks update-kubeconfig --name mkallali-eks-dev"
                      sh "kubectl apply -f k8s-all.yaml"
                      sh "sleep 60"
                      sh "kubectl get nodes"
                      sh "kubectl get deployments"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/graphql-service"
                  }
              }
        }
        stage('Checking if app is up') {
              steps{
                  echo 'Checking if app is up...'
                  withAWS(credentials: 'aws-static', region: 'us-east-2') {
                     sh "aws --region us-east-2 eks update-kubeconfig --name mkallali-eks-dev"
                     sh "curl `kubectl get svc graphql-service -o jsonpath={.status.loadBalancer.ingress[0].hostname}`:8082"
                    
                  }
               }
        }
        stage('Checking rollout') {
              steps{
                  echo 'Checking rollout...'
                  withAWS(credentials: 'aws-static', region: 'us-east-2') {
                     sh "aws --region us-east-2 eks update-kubeconfig --name mkallali-eks-dev"
                     sh "kubectl rollout status deployments/graphql"
                  }
              }
        }
        stage("Cleaning up") {
              steps{
                    echo 'Cleaning up...'
                    sh "docker system prune"
              }
        }
    }
}
