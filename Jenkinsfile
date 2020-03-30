String cron_string = BRANCH_NAME == "master" ? "H 12 * * 1,3" : ""

pipeline {
  agent { label 'ephemeral-linux' }
  options {
    // The Build GPU stage depends on the image from the Push CPU stage
    disableConcurrentBuilds()
  }
  triggers {
    cron(cron_string)
  }
  environment {
    GIT_COMMIT_SHORT = sh(returnStdout: true, script:"git rev-parse --short=7 HEAD").trim()
    GIT_COMMIT_SUBJECT = sh(returnStdout: true, script:"git log --format=%s -n 1 HEAD").trim()
    GIT_COMMIT_AUTHOR = sh(returnStdout: true, script:"git log --format='%an' -n 1 HEAD").trim()
    GIT_COMMIT_SUMMARY = "`<https://github.com/Kaggle/docker-rstats/commit/${GIT_COMMIT}|${GIT_COMMIT_SHORT}>` ${GIT_COMMIT_SUBJECT} - ${GIT_COMMIT_AUTHOR}"
    SLACK_CHANNEL = sh(returnStdout: true, script: "if [[ \"${GIT_BRANCH}\" == \"master\" ]]; then echo \"#kernelops\"; else echo \"#builds\"; fi").trim()
    // See b/152450512
    GITHUB_PAT = credentials('github-pat')
  }

  stages {
    stage('Docker CPU Build') {
      steps {
        sh '''#!/bin/bash
          set -exo pipefail

          ./build | ts
        '''
      }
    }

    stage('Push CPU Pretest Image') {
      steps {
        sh '''#!/bin/bash
          set -exo pipefail
          date
          ./push ci-pretest
        '''
      }
    }

    stage('Test CPU Image') {
      steps {
        sh '''#!/bin/bash
          set -exo pipefail

          date
          ./test
        '''
      }
    }

    stage('Push CPU Image') {
      steps {
        sh '''#!/bin/bash
          set -exo pipefail

          date
          ./push staging
        '''
      }
    }

    stage('Docker GPU Build') {
      agent { label 'ephemeral-linux-gpu' }
      steps {
        sh '''#!/bin/bash
          set -exo pipefail
          docker image prune -f # remove previously built image to prevent disk from filling up
          ./build --gpu | ts
        '''
      }
    }

    stage('Push GPU Pretest Image') {
      agent { label 'ephemeral-linux-gpu' }
      steps {
        sh '''#!/bin/bash
          set -exo pipefail
          date
          ./push --gpu ci-pretest
        '''
      }
    }

    stage('Test GPU Image') {
      agent { label 'ephemeral-linux-gpu' }
      steps {
        sh '''#!/bin/bash
          set -exo pipefail
          date
          ./test --gpu
        '''
      }
    }

    stage('Push GPU Image') {
      agent { label 'ephemeral-linux-gpu' }
      steps {
        sh '''#!/bin/bash
          set -exo pipefail
          date
          ./push --gpu staging
        '''
      }
    }
  }

  post {
    failure {
      slackSend color: 'danger', message: "*<${env.BUILD_URL}console|${JOB_NAME} failed>* ${GIT_COMMIT_SUMMARY} @kernels-backend-ops", channel: env.SLACK_CHANNEL
    }
    success {
      slackSend color: 'good', message: "*<${env.BUILD_URL}console|${JOB_NAME} passed>* ${GIT_COMMIT_SUMMARY}", channel: env.SLACK_CHANNEL
    }
    aborted {
      slackSend color: 'warning', message: "*<${env.BUILD_URL}console|${JOB_NAME} aborted>* ${GIT_COMMIT_SUMMARY}", channel: env.SLACK_CHANNEL
    }
  }
}
