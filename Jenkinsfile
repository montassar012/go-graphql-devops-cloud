pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "TEST PIPELINE"'
        sh '''
                 echo "Multiline shell step to work"
                 ls -alh
                 '''
      }
    }
    stage('CFN-TEMPLATE') {
      steps {
        sh 'echo "TEST PIPELINE"'
        sh '''
                aws --region us-east-2 cloudformation package \
                --template-file ./deploy/roles/cloudformation/files/eks-root.json --output-template /tmp/packed-eks-stacks.json \
                --s3-bucket mkallali-eks-cfn-us-east-2 --use-json
                 '''
      }
    }


  }
}