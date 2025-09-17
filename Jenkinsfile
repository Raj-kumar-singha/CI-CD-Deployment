pipeline {
  agent any

  environment {
    PM2        = "/usr/bin/pm2"       // absolute paths avoid PATH issues
    GUNICORN   = "/usr/bin/gunicorn"
    FRONTEND   = "frontend"
    BACKEND    = "backend"
    FRONTEND_APP = "frontend-app"
    BACKEND_APP  = "backend-app"
    BIND       = "0.0.0.0:5000"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Backend: install & run') {
      steps {
        dir("${BACKEND}") {
          sh '''
            python3 -m pip install --upgrade pip
            [ -f requirements.txt ] && python3 -m pip install -r requirements.txt || true
          '''
        }
        sh '''
          # start once, then reload forever after
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

    stage('Frontend: install & run') {
      steps {
        dir("${FRONTEND}") { sh 'npm ci || npm install' }
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
