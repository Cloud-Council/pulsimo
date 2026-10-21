# Configuration

Pulsimo is configured with one `.env` file next to the Compose file. Start from `.env.example`, change the values you need, and recreate the services that read them:

```bash
docker compose -f docker-compose.prod.yml up -d
```

At a minimum, set `HOST_IP` and replace `POSTGRES_PASSWORD`, `JWT_SECRET` and `METRICS_SECRET_KEY`.

- [Configuration reference](environment-variables.md): Every .env value: what it controls, which service reads it, defaults, ranges and recipes.
- [Installation](../installation/README.md): Where the .env file comes from and the first values to set.
- [Running in production](../production.md): Secrets, HTTPS, firewall, backups, retention and upgrades.

---

[Back to the contents](../README.md)
