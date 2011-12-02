name "internal_dns"
description "Configure and install Bind to function as an internal DNS server."
override_attributes "bind" => {
  "masters" => [ "1.2.3.4", "1.2.3.5", "1.2.3.6" ],
  "ipv6_listen" => true,
  "zonetype" => "slave",
  "zones" => [
    "example.com",
    "foo.example.com",
    "bar.example.com"
  ],
  "ad" => {
    "server" => "example.com",
    "root_tree" => "dc=example,dc=com",
    "domainzones" => "cn=MicrosoftDNS,dc=DomainDnsZones,dc=example,dc=com",
    "binddn" => "cn=service-account,ou=Service Accounts,ou=Machine Room,dc=example,dc=com",
    "bindpw" => "password"
  },
  "options" => [
    "check-names slave ignore;",
    "multi-master yes;",
    "provide-ixfr yes;",
    "recursive-clients 10000;",
    "request-ixfr yes;",
    "allow-update-forwarding { any; };",
  ],
},
"resolver" => {
  "search" => "marshall.edu",
  "nameservers" => [ "1.2.3.7","1.2.3.8","1.2.3.9"],
  "is_dnsserver" => true
}
run_list "recipe[bind]", "recipe[resolver]"
