node {
  try {
    stage("Checkout") {
        checkout scm
    }
    
    stage("Environment") {
      sh "git --version"
      echo "Branch: ${env.BRANCH_NAME}"
      sh "docker -v"
      sh "printenv"
    }
    
    stage("Deploy proxy") {
      sh "docker build -t k64-playground-proxy --no-cache ."
      sh "docker tag k64-playground-proxy:latest rberton/k64-playground-proxy:latest"
      withCredentials([usernamePassword( credentialsId: "Dockerhub", usernameVariable: "USERNAME", passwordVariable: "PASSWORD")]) {
        sh "docker login -u ${USERNAME} -p ${PASSWORD}"
        sh "docker push rberton/k64-playground-proxy:latest"
      }
      sh "docker rmi k64-playground-proxy"
    }
  }
  catch (err) {
    throw err
  }
}