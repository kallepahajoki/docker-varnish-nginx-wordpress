#!/usr/bin/env bash
cat > vcl/generated.vcl <<:EOF:
# This is my VCL file for Varnish 4.0.2 & Wordpress 4.0
#
# ASSUME The builtin VCL is called afterwards.
#

# Specify VCL new 4.0 format.
vcl 4.0;

# Imports
import std;
:EOF:

echo "include \"/data/header.vcl\";" >> vcl/generated.vcl
for site in `ls ../sites`
do
    SITENAME="`echo $site|tr -d .`"
    #echo "include \"/data/$site.vcl\";" >> vcl/generated.vcl

    cat >> vcl/generated.vcl << :EOF:

    backend $SITENAME {
        .host = "$SITENAME";
        .port = "8080";
    }
:EOF:
done
for site in `ls ../sites`
do
    SITENAME="`echo $site|tr -d .`"

    cat >> vcl/recv.vcl << :EOF:

        if (req.http.host ~ "^(.*\.)\?${site}\$") {
            set req.backend_hint = $SITENAME;
        }

:EOF:
done

