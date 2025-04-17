pipeline {
    agent any

    environment {
        ACR_NAME = 'mytestacrjenkins'
        IMAGE_NAME = 'test-html-app'
        RESOURCE_GROUP = 'rg-devopsproj2'
        APP_NAME = 'html-app-service-devopsproj2'
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
	KUBECONFIG = credentials('kubeconfig') // Referencing the kubeconfig credential
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MdAyubz/html-app-service.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest -f dockerfile ."
                }
            }
        }

        stage('Login to ACR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-creds', usernameVariable: 'ACR_USERNAME', passwordVariable: 'ACR_PASSWORD')]) {
                    sh "echo $ACR_PASSWORD | docker login ${ACR_LOGIN_SERVER} -u $ACR_USERNAME --password-stdin"
                }
            }
        }

        stage('Push to ACR') {
            steps {
                sh "docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to AKS') {
            steps {
                
		sh '''
                    chmod +x deploy-to-aks.sh
                    ./deploy-to-aks.sh
                '''
		
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-creds', usernameVariable: 'ACR_USERNAME', passwordVariable: 'ACR_PASSWORD')]) {
                    sh """
                        az webapp config container set \
                          --name ${APP_NAME} \
                          --resource-group ${RESOURCE_GROUP} \
                          --docker-custom-image-name ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest \
                          --docker-registry-server-url https://${ACR_LOGIN_SERVER} \
                          --docker-registry-server-user $ACR_USERNAME \
                          --docker-registry-server-password $ACR_PASSWORD
                    """
                }
            }
        }
    }

    post {
        failure {
            echo '❌ Pipeline failed!'
        }
        success {
            echo '✅ Successfully deployed to ACR, AKS & App Service!'
        }
    }
}

