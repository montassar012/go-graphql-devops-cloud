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

  }
}