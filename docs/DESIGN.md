# Design Notes: Hybrid Cloud Connectivity with Transit Gateway and Site-to-Site VPN

This document expands on the architecture summarized in the root [README.md](../README.md).

## 1. IP Addressing Plan

| Account | VPC | CIDR |
|---|---|---|
| Account A | Prod VPC | 10.0.0.0/16 |
| Account A | Dev VPC | 10.1.0.0/16 |
| Account A | Staging VPC | 10.2.0.0/16 |
| Account A | Route 53 Resolver / Network Firewall VPC | 172.16.0.0/24, 172.16.1.0/24, 172.16.2.0/24 |
| Account B | Staging VPC | 10.15.0.0/16 |
| Account B | Prod VPC | 10.16.0.0/16 |
| Account B | Dev VPC | 10.17.0.0/16 |

All ranges must be unique and non-overlapping across every VPC, every account, and the on-premises corporate network,
since they will all be reachable through the same Transit Gateway route tables.

## 2. Transit Gateway Route Table Strategy

We recommend at minimum three Transit Gateway route tables:

1. **Production Route Table** — associated with Prod VPC attachments; propagates only routes from other Prod
   attachments, the Network Firewall inspection attachment, and the on-premises attachments (Direct Connect / VPN).
2. **Non-Production Route Table** — associated with Dev and Staging VPC attachments; propagates routes among
   non-production VPCs and to on-premises (if permitted by policy), but not to Prod.
3. **Inspection Route Table** — associated with the Network Firewall VPC attachment, used to route traffic back out
   to its final destination after inspection.

This design enforces environment segmentation: Dev/Staging traffic cannot reach Prod (and vice versa) unless explicitly
permitted by adding routes/associations.

## 3. Traffic Inspection Flow

1. Spoke VPC sends traffic to the Transit Gateway.
2. The associated route table sends the traffic to the Network Firewall VPC attachment instead of directly to the
   destination attachment.
3. AWS Network Firewall evaluates the traffic against stateful/stateless rule groups.
4. Allowed traffic is routed back into the Transit Gateway (via the Inspection Route Table) toward its true
   destination (another VPC, another account, or on-premises).

## 4. Hybrid Connectivity Resiliency

- **Primary path**: AWS Direct Connect Gateway associated with the Transit Gateway, terminating a Direct Connect
  Virtual Interface (VIF) at the corporate data center.
- **Backup path**: AWS Site-to-Site VPN connection attached directly to the Transit Gateway, using BGP over IPsec
  tunnels to a Customer Gateway device on-premises.
- **Failover behavior**: Configure BGP AS-PATH prepending (or static route priority) so that on-premises routers and
  the Transit Gateway both prefer the Direct Connect path under normal conditions, and automatically fail over to the
  VPN path if BGP sessions over Direct Connect go down.
- For higher resiliency, consider a second Direct Connect connection (diverse location/device) before relying on VPN
  as the sole backup.

## 5. DNS Resolution (Split-Horizon)

- **Outbound Resolver endpoint** (in the Resolver VPC): forwards DNS queries for on-premises domains (e.g.,
  `corp.example.internal`) from AWS resources to the corporate DNS servers, via Resolver rules associated with the
  relevant VPCs.
- **Inbound Resolver endpoint** (in the Resolver VPC): allows on-premises DNS servers to forward queries for AWS
  private hosted zone domains (e.g., `internal.aws.example.com`) into Route 53 Resolver.
- Both endpoints are reachable from other VPCs/accounts through the Transit Gateway, avoiding the need to deploy a
  Resolver endpoint per account.

## 6. Scaling the Architecture

- New spoke accounts attach to the existing Transit Gateway share (via AWS RAM) without any change to the hub
  account.
- New Regions get their own Transit Gateway, interconnected to existing hub(s) via Transit Gateway peering.
- Route table associations/propagations should be reviewed whenever a new spoke account or VPC is onboarded, to
  ensure segmentation rules remain correctly enforced.

## 7. Operational Metrics (Optional)

If enabled in your deployment variables, this reference implementation can emit anonymous usage metrics (solution
version, Region, number of attached accounts/VPCs) to help maintainers understand adoption patterns. This is
controlled by a boolean variable (e.g., `enable_operational_metrics`) in `iac/account-a/envs/*.tfvars` and defaults to
your organization's preference — review and set explicitly before deploying.
