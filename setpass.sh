#!/bin/bash

ADMIN_DN="cn=admin,dc=rks,dc=com"
LDAP_SERVER="ldap://127.0.0.1"

declare -A USERS=(
  [angling]="angling"
  [brama]="brama"
  [cemara]="cemara"
  [damar]="damar"
  [minak]="minak"
)

echo -n "Masukkan password ADMIN LDAP: "
read -s ADMIN_PASS
echo

for user in "${!USERS[@]}"; do
  pass="${USERS[$user]}"
  DN="uid=$user,ou=siber,dc=rks,dc=com"

  echo ">> Setting password untuk $user ..."
  ldappasswd -H $LDAP_SERVER \
    -D "$ADMIN_DN" -w "$ADMIN_PASS" \
    -s "$pass" "$DN"

  if [ $? -eq 0 ]; then
    echo "[OK] $user password = $pass"
  else
    echo "[FAILED] $user"
  fi
done
