# Intentionally uses an older base image tag to surface CVEs
FROM node:16-buster

# Running as root (no USER instruction) - common finding
WORKDIR /app

# Copies everything, including potential secrets/config
COPY . .

RUN npm install --production

# Hardcoded credential in ENV (secrets scan should flag this)
ENV DB_PASSWORD="SuperSecretPassword123!"

EXPOSE 3000

CMD ["node", "server.js"]
