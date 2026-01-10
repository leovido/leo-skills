# DevOps Skills & Best Practices

DevOps standards, CI/CD pipelines, and containerization practices.

## Table of Contents

- [CI/CD](#cicd)
- [Docker](#docker)

---

## CI/CD

### GitHub Actions

When creating a Pull Request, the following checks must run:

1. **Security Checks**
   - Dependency vulnerability scanning
   - Use tools like `pnpm audit`, Dependabot, or Snyk

2. **SonarQube Analysis**
   - Code quality and security analysis
   - Requires initial SonarQube project setup
   - Configure quality gates and thresholds

3. **Unit Tests**
   - Run full test suite
   - Generate coverage reports
   - Fail if tests fail or coverage drops below threshold

4. **Linting**
   - Run Biome linting
   - Fail on linting errors
   - Optionally auto-fix and commit changes

**Example GitHub Actions workflow:**

```yaml
name: PR Checks

on:
  pull_request:
    branches: [main, develop]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm audit --audit-level=moderate

  sonarqube:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - name: SonarQube Scan
        uses: sonarsource/sonarqube-scan-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run test:ci
      - uses: codecov/codecov-action@v3
        with:
          token: ${{ secrets.CODECOV_TOKEN }}

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run lint
      - run: pnpm run format:check
```

---

## Docker

### Containerization

Set up Docker and Docker Compose for local development and deployment.

**Docker Compose Structure:**

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - .:/app
      - /app/node_modules
    depends_on:
      - prometheus
      - grafana

  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus_data:/prometheus

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
```

**Dockerfile Best Practices:**

- Use multi-stage builds for smaller images
- Leverage layer caching
- Use specific version tags for base images
- Run as non-root user when possible
- Include health checks

**Additional Services:**
- Database services (PostgreSQL, MySQL, MongoDB) can be added to docker-compose.yml as needed
- Configure service dependencies appropriately

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

## Notes

- This document should be reviewed and updated regularly as best practices evolve
- Team-specific additions and modifications are encouraged
- When in doubt, refer to official documentation and community standards

