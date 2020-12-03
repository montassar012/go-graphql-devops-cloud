pipeline {
  agent any
  stages {
    stage('Build') {
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
         stage('Security Scan') {
              steps { 
                 aquaMicroscanner imageName: 'graphql:latest', notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
              }
         }
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
                    //  sh "kubectl config use-context arn:aws:eks:us-east-2:960920920983:cluster/mkallali-eks-dev"
                      sh "kubectl apply -f k8s-all.yaml"
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
                     sh "curl ad0e6a88870a9477989eb79393197b59-2120449898.us-east-2.elb.amazonaws.com:8082"
                    
                  }
               }
        }
        stage('Checking rollout') {
              steps{
                  echo 'Checking rollout...'
                  withAWS(credentials: 'aws-static', region: 'us-east-2') {
                     sh "aws --region us-east-2 eks update-kubeconfig --name mkallali-eks-dev"
                     sh "kubectl rollout status deployments/mkallali-eks-dev"
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
