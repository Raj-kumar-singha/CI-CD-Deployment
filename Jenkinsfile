pipeline {
  agent any

  environment {
    # Use absolute paths so Jenkins jobs always find them
    PM2       = "/usr/bin/pm2"
    GUNICORN  = "/usr/bin/gunicorn"
    BACKEND   = "backend"
    FRONTEND  = "frontend"
    BACKEND_APP = "backend-app"
    FRONTEND_APP = "frontend-app"
    BIND      = "0.0.0.0:5000"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Backend: Install & Run') {
      steps {
        dir("${BACKEND}") {
          sh '''
            python3 -m pip install --upgrade pip
            if [ -f requirements.txt ]; then
              python3 -m pip install -r requirements.txt
            fi
          '''
        }
        sh '''
          if ${PM2} describe ${BACKEND_APP} > /dev/null; then
            ${PM2} reload ${BACKEND_APP} --update-env
          else
            cd ${BACKEND}
            ${PM2} start "${GUNICORN} -w 4 -b ${BIND} app:app" --name ${BACKEND_APP}
          fi
          ${PM2} save
        '''
      }
    }

    stage('Frontend: Install & Run') {
      steps {
        dir("${FRONTEND}") {
          sh '''
            npm ci || npm install
          '''
        }
        sh '''
          if ${PM2} describe ${FRONTEND_APP} > /dev/null; then
            ${PM2} reload ${FRONTEND_APP} --update-env
          else
            cd ${FRONTEND}
            ${PM2} start server.js --name ${FRONTEND_APP}
          fi
          ${PM2} save
        '''
      }
    }
  }
}
