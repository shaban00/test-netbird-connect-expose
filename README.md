# test-netbird-connect-expose

End-to-end tests for [`shaban00/netbird-connect`](https://github.com/shaban00/netbird-connect)
and [`shaban00/netbird-expose`](https://github.com/shaban00/netbird-expose) against a real
NetBird deployment.

| Job                 | What it checks                                                                  |
| ------------------- | ------------------------------------------------------------------------------- |
| `connect`           | Install (per client repo), join the network, wait for a peer/host, the outputs  |
| `expose (<app>)`    | One job per app below, exposed in the background and tested through the proxy   |

| App             | Protocol | What it tests                                                                  |
| --------------- | -------- | ------------------------------------------------------------------------------ |
| `static`        | http     | `container-port`, `check-path`, a 20 MB download arriving intact               |
| `python-api`    | http     | `app-env` reaching the app, a 1 MB POST body, the proxy's forwarding headers   |
| `websocket`     | http     | A WebSocket upgrade and echo through the proxy                                 |
| `slow-start`    | http     | An app that needs 30 s to start: the response check waits instead of failing  |
| `https-backend` | https    | The proxy talking TLS to an app with a self-signed certificate                 |
| `compose-redis` | http     | A two-service compose app (web + redis) configured through `app-env`           |
| `password`      | http     | The proxy does not serve the app without the password                          |
| `pin`           | http     | The proxy does not serve the app without the PIN                               |
| `tcp-redis`     | tcp      | Redis `PING` through the proxy's TCP port (opt-in, see below)                  |
| `udp-dns`       | udp      | A DNS query through the proxy's UDP port (opt-in, see below)                   |

Each app lives in `apps/<app>/` and its checks in `tests/<app>.sh`.

The tests run on pushes to `main`, pull requests, weekly, and on demand (Actions > Test > Run workflow).

## NetBird setup

1. **Settings > Setup Keys**: create a **reusable**, **ephemeral** key that auto-assigns a group such as `github-actions`.
2. **Settings > Clients**: enable **Peer Expose** and allow the `github-actions` group.
3. A NetBird reverse proxy must be running for the account.
4. For `NETBIRD_WAIT_FOR_PEER` / `NETBIRD_WAIT_FOR_HOST`: an access policy from `github-actions` to that peer and port.

## Repository settings

Settings > Secrets and variables > Actions.

| Name                     | Kind     | Required | Example                                   |
| ------------------------ | -------- | -------- | ----------------------------------------- |
| `NETBIRD_SETUP_KEY`      | secret   | yes      | the setup key from step 1                 |
| `NETBIRD_MANAGEMENT_URL` | secret   | yes      | `https://netbird.example.com`             |
| `NETBIRD_CLIENT_REPOS`   | variable | no       | `["netbirdio/netbird","owner/netbird"]`   |
| `NETBIRD_CLIENT_REPO`    | variable | no       | `owner/netbird`                           |
| `NETBIRD_WAIT_FOR_PEER`  | variable | no       | `my-server`                               |
| `NETBIRD_WAIT_FOR_HOST`  | variable | no       | `my-server:22`                            |
| `NETBIRD_TEST_L4`        | variable | no       | `true` to run the TCP and UDP tests       |
| `NETBIRD_L4_TCP_PORT`    | variable | no       | `16379` (default)                         |
| `NETBIRD_L4_UDP_PORT`    | variable | no       | `15353` (default)                         |

Without the two secrets the tests are skipped with a warning.

## TCP and UDP tests

The proxy listens on a separate port for each TCP or UDP service. Before setting
`NETBIRD_TEST_L4=true`, publish both ports on the proxy host (its `docker-compose.yml`,
e.g. `- '16379:16379'` and `- '15353:15353/udp'`) and open them in its firewall.
