Simple Terraform module to create Route53 DNS records for a domain with G Suite.

## Usage

Minimum configuration

    module "example_gsuite" {
      source = "https://github.com/scottylogan/tf_route53_gsuite.git"
      domain = "example.com"
    }

This would create the _example.com_ zone, and the following records:

    example.com.  86400  IN  NS   ns-1234.awsdns-12.org.
    example.com.  86400  IN  NS   ns-5678.awsdns-34.co.uk.
    example.com.  86400  IN  NS   ns-9123.awsdns-56.com.
    example.com.  86400  IN  NS   ns-4567.awsdns-78.net.

    example.com.    300  IN  TXT  "v=spf1 include:_spf.google.com ~all"
    example.com.    300  IN  SPF  "v=spf1 include:_spf.google.com ~all"
    
    example.com.    300  IN  MX   10 aspmx.l.google.com.
    example.com.    300  IN  MX   20 alt1.aspmx.l.google.com.
    example.com.    300  IN  MX   20 alt2.aspmx.l.google.com.
    example.com.    300  IN  MX   30 aspmx2.googlemail.com.
    example.com.    300  IN  MX   30 aspmx3.googlemail.com.
    example.com.    300  IN  MX   30 aspmx4.googlemail.com.
    example.com.    300  IN  MX   30 aspmx5.googlemail.com.

## Variables

### domain

Defines the domain name. Required.

### ttl

Defines the default DNS record TTL (in seconds). Defaults to _300_.

### ns_ttl

Defines the DNS NS record TTL (in seconds). Defaults to _86400_ (24 hours).

### site_verifier

The value for the `google-site-verifier` TXT record. If no value is specified, no `google-site-verifier` TXT entry will be created.

### spf

The value for the SPF record. This will also be used to create a TXT record. Default is _"v=spf1 include:_spf.google.com ~all"_.

### extra_txts

A list of extra TXT record values. Default is an empty list.

### dkim

The Google DKIM public key value. If this is specified, a record for `google._domainkey.$DOMAIN` will be created, e.g.:

    google._domainkey.example.com. 300 IN  TXT  "v=DKIM1; k=rsa; p=MIGf...AB"

## Configuration Example

This configuration

    module "base_dns" {
      source        = "https://github.com/scottylogan/tf_route53_gsuite.git"
      domain        = "example.com"
      site_verifier = "a..._b..._c..."
      dkim          = "MIGF...AB"
      extra_txts = [
        "keybase-site-verification=f..._g..._h..."
      ]
    }

will generate DNS records like these:

    example.com.                   86400 NS  ns-1234.awsdns-12.org.
    example.com.                   86400 NS  ns-5678.awsdns-34.co.uk.
    example.com.                   86400 NS  ns-9123.awsdns-56.com.
    example.com.                   86400 NS  ns-4567.awsdns-78.net.

    example.com.                     300 TXT "v=spf1 include:_spf.google.com ~all"
    example.com.                     300 TXT "keybase-site-verification=f..._g..._h"
    example.com.                     300 TXT "google-site-verification=a..._b..._c..."

    google._domainkey.example.com.   300 TXT "v=DKIM1; k=rsa; p=MIGF...AB"
    example.com.                     300 SPF "v=spf1 include:_spf.google.com ~all"
    
    example.com.                     300 MX  10 aspmx.l.google.com.
    example.com.                     300 MX  20 alt1.aspmx.l.google.com.
    example.com.                     300 MX  20 alt2.aspmx.l.google.com.
    example.com.                     300 MX  30 aspmx2.googlemail.com.
    example.com.                     300 MX  30 aspmx3.googlemail.com.
    example.com.                     300 MX  30 aspmx4.googlemail.com.
    example.com.                     300 MX  30 aspmx5.googlemail.com.

# Testing

There's a `Makefile` that can be used to run the test configurtion in `test/test.tf` and compare the results to `test/plan.txt`:

    % make test
    installing...
    running test...
    verifying result...
    ok

If the test fails, it will show the location of a diff between the expected and actual outputs:

    % make test
    installing...
    running test...
    verifying result...
    FAILED -- see test/test.diff
