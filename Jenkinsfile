pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Raj-kumar-singha/CI-CD-Deployment.git'
            }
        }

        stage('Backend - Flask') {
            steps {
                dir('backend') {
                    sh 'pip3 install -r requirements.txt'
                    sh 'pm2 restart backend || pm2 start "gunicorn -w 4 -b 0.0.0.0:5000 app:app" --name backend'
                }
            }
        }

        stage('Frontend - Express') {
            steps {
                dir('frontend') {
                    sh 'npm install'
                    sh 'pm2 restart frontend || pm2 start server.js --name frontend'
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful ✅"
        }
        failure {
            echo "Deployment Failed ❌"
        }
    }
}
