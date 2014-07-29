OpenShift ownCloud Deploy
===

This script can be used to deploy ownCloud to OpenShift. Note that for production it's better to use the [QuickStart](https://github.com/openshift/owncloud-openshift-quickstart) which can be installed via the OpenShift interface.

# Use
1. Create an account on `openshift.com`
2. Update your SSH keys
3. Create an application with:
	- `PHP 5.4`
	- `MySQL`
4. Find the `Source Code Url` on OpenShift, it looks like `ssh://324533asfdea0c3523452345382ec1add000241@{app-name}-{namespace}.rhcloud.com/~/git/{app-name}-.git/`
5. execute the `od.sh` script with the correct arguments.
6. Enjoy!

# Arguments

Name | Use | Info
---  | --- | ---
`-o` | `-o sourceurl` | See step 4 of #use
`-a` | `-a news -a chat -a calendar` | This will install the provided apps