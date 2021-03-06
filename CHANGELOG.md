splunk CHANGELOG
================
This file is used to list changes made in each version of the splunk cookbook.

v1.8.1 (2016-06-10) - erogneby
-------------------

- adding support for custom package install for forwarder.

v1.8.0 (2016-03-30) - akemner
-------------------

- reduce kitchen.ec2 concurrency to 1, gut unused platforms and testing suites

v1.7.3 (2016-03-30) - akemner
-------------------

- update service restarts in splunk_app to delayed to speed up app creation if multiple apps

v1.7.2 (2016-03-16) - rlipke
-------------------

- Add windows compatible testing

v1.7.1 (2016-03-10) - akemner
-------------------

- fix splunk urls

v1.7.0 (2016-02-22) - akemner
-------------------

- fix splunk_apps templates functionality and add testing

v1.6.5 (2016-02-01) - akemner
-------------------

- fix template bugs

v1.6.4 (2016-02-01) - akemner
-------------------

- remove download_splunk resource

v1.6.3 (2016-01-25) - akemner
-------------------

- fix splunk_app update bug and add more testing. restructure integration test suites to better align with community cookbook suites that get tested in CI

v1.6.2 (2015-11-24) - akemner
-------------------

- fix path in spec_helper

v1.6.1 (2015-11-24) - akemner
-------------------

- update readme.

v1.6.0 (2015-11-19) - kbvincent
-------------------

- Adding windows support. (GDAES-2774)

v1.5.0 (2015-11-10) - kbvincent
-------------------

- adding support for upgrading splunk_apps. (GDAES-2661)

v1.4.2 (2015-11-04) - kbvincent
-------------------

- adding support for splunk-launch.conf, creating SPLUNK_ENVIRONMENT variable.


v1.4.1 (2015-10-07) - akemner
-------------------

- support for data cloning with load balancing in client.rb, providing splunk_servers as attribute rather then search


v1.4.0 (2015-09-13)
-------------------

Also known as the "it's about time!" release

- support for splunk universal client running as a server
- update splunk install version to 6.2.1
- added attribute for rate limiting maxKBps throughput
- Add recipe to setup indexer cluster
- use `declare_resource` method to setup the right local-file package resource for `splunk_installer` definition
- lots of fixes for specs and tests

v1.3.0 (2014-10-24)
-------------------

- Implement dynamic inputs.conf and outputs.conf configuration based on attributes in client recipe.

v1.2.2 (2014-08-25)
-------------------

- Implement capability to run Splunk as a non-root user
- Allow web port to be specified

v1.2.0 (2014-05-06)
-------------------
- [COOK-4621] - upgrade to Splunk 6.0.3 (for heartbleed)
- add ubuntu 14.04 to test-kitchen

v1.1.0 (2014-03-19)
-------------------
- [COOK-4450] - upgrade to Splunk 6.0.2
- [COOK-4451] - unbreak test harness

v1.0.4
------
- template sources should have .erb explicitly
- don't show the password in the execute resource name

v1.0.2
------
- Splunk init script supports status, use it in `stop` action for upgrade.

v1.0.0
-----
- Initial release
