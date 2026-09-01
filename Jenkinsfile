pipeline {
    agent none

    environment {
        AZURE_CREDENTIALS = 'Azure-SP'
        TF_DIR = 'Environment/preprod'
    }

    stages {

        stage('Checkout SCM') {
            agent { label 'terraform-agent' }

            steps {
                checkout scm
            }
        }

        stage('Agent Test') {
            agent { label 'terraform-agent' }

            steps {
                sh '''
                    echo "======================================"
                    echo "Jenkins Agent Information"
                    echo "======================================"

                    hostname
                    whoami

                    echo "Terraform Version:"
                    terraform version

                    echo "Azure CLI Version:"
                    az version
                '''
            }
        }

        stage('Azure Login') {
            agent { label 'terraform-agent' }

            steps {
                withCredentials([
                    azureServicePrincipal(
                        credentialsId: "${AZURE_CREDENTIALS}",
                        subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                        clientIdVariable: 'AZURE_CLIENT_ID',
                        clientSecretVariable: 'AZURE_CLIENT_SECRET',
                        tenantIdVariable: 'AZURE_TENANT_ID'
                    )
                ]) {
                    sh '''
                        set +x

                        az login \
                          --service-principal \
                          --username "$AZURE_CLIENT_ID" \
                          --password "$AZURE_CLIENT_SECRET" \
                          --tenant "$AZURE_TENANT_ID" \
                          >/dev/null

                        az account set \
                          --subscription "$AZURE_SUBSCRIPTION_ID"

                        echo "Azure Login Successful"

                        az account show \
                          --query "{Subscription:name, SubscriptionId:id, TenantId:tenantId}" \
                          --output table
                    '''
                }
            }
        }

        stage('Terraform Init') {
            agent { label 'terraform-agent' }

            steps {
                dir("${TF_DIR}") {
                    withCredentials([
                        azureServicePrincipal(
                            credentialsId: "${AZURE_CREDENTIALS}",
                            subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                            clientIdVariable: 'AZURE_CLIENT_ID',
                            clientSecretVariable: 'AZURE_CLIENT_SECRET',
                            tenantIdVariable: 'AZURE_TENANT_ID'
                        )
                    ]) {
                        sh '''
                            set +x

                            az login \
                              --service-principal \
                              --username "$AZURE_CLIENT_ID" \
                              --password "$AZURE_CLIENT_SECRET" \
                              --tenant "$AZURE_TENANT_ID" \
                              >/dev/null

                            az account set \
                              --subscription "$AZURE_SUBSCRIPTION_ID"

                            terraform init -reconfigure
                        '''
                    }
                }
            }
        }

        stage('Terraform Validate') {
            agent { label 'terraform-agent' }

            steps {
                dir("${TF_DIR}") {
                    sh '''
                        terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            agent { label 'terraform-agent' }

            steps {
                dir("${TF_DIR}") {
                    withCredentials([
                        azureServicePrincipal(
                            credentialsId: "${AZURE_CREDENTIALS}",
                            subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                            clientIdVariable: 'AZURE_CLIENT_ID',
                            clientSecretVariable: 'AZURE_CLIENT_SECRET',
                            tenantIdVariable: 'AZURE_TENANT_ID'
                        )
                    ]) {
                        sh '''
                            set +x

                            az login \
                              --service-principal \
                              --username "$AZURE_CLIENT_ID" \
                              --password "$AZURE_CLIENT_SECRET" \
                              --tenant "$AZURE_TENANT_ID" \
                              >/dev/null

                            az account set \
                              --subscription "$AZURE_SUBSCRIPTION_ID"

                            terraform plan -out=tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            agent { label 'terraform-agent' }

            steps {
                dir("${TF_DIR}") {
                    withCredentials([
                        azureServicePrincipal(
                            credentialsId: "${AZURE_CREDENTIALS}",
                            subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID',
                            clientIdVariable: 'AZURE_CLIENT_ID',
                            clientSecretVariable: 'AZURE_CLIENT_SECRET',
                            tenantIdVariable: 'AZURE_TENANT_ID'
                        )
                    ]) {
                        sh '''
                            set +x

                            az login \
                              --service-principal \
                              --username "$AZURE_CLIENT_ID" \
                              --password "$AZURE_CLIENT_SECRET" \
                              --tenant "$AZURE_TENANT_ID" \
                              >/dev/null

                            az account set \
                              --subscription "$AZURE_SUBSCRIPTION_ID"

                            terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "======================================"
            echo "Terraform Apply Successful"
            echo "======================================"
        }

        failure {
            echo "======================================"
            echo "Terraform Pipeline Failed"
            echo "Check Jenkins Console Output"
            echo "======================================"
        }
    }
}

