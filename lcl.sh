# Export all Environment Variables
set -o allexport; source .env; set +o allexport

# Build Web UI Docker Image
docker build -t  ${CONTAINER_WEB_UI} .

# Get App Package Version
PACKAGE_VERSION=$(node -p -e "require('./ui/package.json').version")

# Tag Docker Image for Deployment to GCP. 
docker tag ${CONTAINER_WEB_UI} gcr.io/${GCP_PROJECT}/${CONTAINER_WEB_UI}:${PACKAGE_VERSION}

# Push Docker Image to GCP GCR 
docker push gcr.io/${GCP_PROJECT}/${CONTAINER_WEB_UI}:${PACKAGE_VERSION}

# Run the Container Locally
docker kill ${CONTAINER_WEB_UI}*
docker container prune -f
docker image rm ${CONTAINER_WEB_UI}*
docker run -i --name ${CONTAINER_WEB_UI} -p 9090:80 ${CONTAINER_WEB_UI}:${PACKAGE_VERSION}

