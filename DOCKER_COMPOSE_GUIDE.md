# Docker Compose Test Environment

This docker-compose setup creates a complete testing environment with:
- **Kafka** (port 9092)
- **Zookeeper** (port 2181)
- **Kafbat UI** (port 8080)
- **Julie-Ops** (Kafka Topology Builder)

## Quick Start

1. **Start all services:**
   ```bash
   docker-compose up -d
   ```

2. **Access Kafbat UI:**
   Open your browser to http://localhost:8080 to view and manage Kafka topics

3. **Run Julie-Ops commands:**
   ```bash
   # Exec into the julie-ops container
   docker-compose exec julie-ops bash
   
   # Example: Run topology builder with the example descriptor
   julie-ops-cli.sh \
     --brokers kafka:29092 \
     --clientConfig /config/topology-builder-docker.properties \
     --topology /config/descriptor-docker-test.yaml
   
   # Or run directly without exec
   docker-compose exec julie-ops julie-ops-cli.sh \
     --brokers kafka:29092 \
     --clientConfig /config/topology-builder-docker.properties \
     --topology /config/descriptor-docker-test.yaml
   ```

4. **View logs:**
   ```bash
   # All services
   docker-compose logs -f
   
   # Specific service
   docker-compose logs -f kafka
   docker-compose logs -f julie-ops
   ```

5. **Stop all services:**
   ```bash
   docker-compose down
   ```

## Julie-Ops Configuration

The julie-ops container mounts two volumes:
- `./example` → `/config` (contains properties and descriptor files)
- `./topologies` → `/topologies` (for custom topology files)

### Example Usage

Create a simple topology descriptor in `example/descriptor-test.yaml`:

```yaml
---
context: "test"
projects:
  - name: "myProject"
    topics:
      - name: "test.topic.a"
        config:
          replication.factor: "1"
          num.partitions: "3"
      - name: "test.topic.b"
        config:
          replication.factor: "1"
          num.partitions: "1"
```

Then run:
```bash
docker-compose exec julie-ops julie-ops-cli.sh \
  --brokers kafka:29092 \
  --clientConfig /config/topology-builder-docker.properties \
  --topology /config/descriptor-test.yaml
```

## Useful Commands

### Kafka Producer/Consumer Testing
```bash
# Produce messages
docker-compose exec kafka kafka-console-producer \
  --bootstrap-server localhost:9092 \
  --topic test.topic.a

# Consume messages
docker-compose exec kafka kafka-console-consumer \
  --bootstrap-server localhost:9092 \
  --topic test.topic.a \
  --from-beginning
```

### List Topics
```bash
docker-compose exec kafka kafka-topics \
  --bootstrap-server localhost:9092 \
  --list
```

## Troubleshooting

### Kafka not starting
- Ensure ports 9092 and 2181 are not already in use
- Check logs: `docker-compose logs kafka`

### Julie-Ops connection issues
- Verify Kafka is running: `docker-compose ps`
- Check bootstrap server in config files points to `kafka:29092` (internal) or `localhost:9092` (from host)

### Clean restart
```bash
# Stop and remove all containers and volumes
docker-compose down -v

# Rebuild and start
docker-compose up -d
```

## Ports

- **9092** - Kafka (external access)
- **29092** - Kafka (internal docker network)
- **2181** - Zookeeper
- **8080** - Kafbat UI

## Notes

- This is a **development/testing** setup with minimal configuration
- No authentication/authorization configured
- Single Kafka broker with replication factor 1
- Data is ephemeral (removed with `docker-compose down -v`)
