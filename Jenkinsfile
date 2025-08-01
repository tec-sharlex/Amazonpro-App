pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/tec-sharlex/Amazonpro-App.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner \
  -Dsonar.projectKey=Amazonpro7 \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://13.221.140.70:9000 \
  -Dsonar.login=sqp_4b4d468c31686bd15031b25424bb3a7826df78d1'''
                }
            }
        }
         stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins' 
                }
            } 
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                       sh "docker build -t amazon-clone ."
                       sh "docker tag amazon-clone tecsharlex/amazon-clone:latest "
                       sh "docker push tecsharlex/amazon-clone:latest "
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image tecsharlex/amazon-clone:latest > trivyimage.txt" 
            }
        }
        stage('Deploy to container'){
            steps{
                sh 'docker run -d --name amazon-clone -p 3000:3000 tecsharlex/amazon-clone:latest'
            }
        }
    }
}