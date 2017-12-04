# README

Ruby backoffice integration app for Gentics Mesh CMS API. Ensure you have the Mesh CMS running somewhere in a terminal. Obtain here: https://getmesh.io/Download and run with Java.

Thor tasks added:

Create a schema for longform-style articles

`thor mesh:schema hello lib/mesh/schemas/longform.json.erb`

This task calls the Mesh API to get an Auth token and then reads a JSON File/ERB template and POSTs it to the `/schemas` endpoint.
