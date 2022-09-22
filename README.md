# aws-ec2-opensimulator

Run a [Open Simulator](http://opensimulator.org/wiki/Main_Page) grid server in a AWS [EC2](https://aws.amazon.com/ec2) instance.

## Dependencies

- [AWS CLI](https://aws.amazon.com/cli)

### AWS requirements

In order to successfully deploy your application you must have [set-up your AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/gs-cli.html) and have [created an IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) with the following [policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage.html):

- [IAMFullAccess](https://console.aws.amazon.com/iam/home#/policies/arn%3Aaws%3Aiam%3A%3Aaws%3Apolicy%2FIAMFullAccess)
- [AmazonEC2FullAccess](https://console.aws.amazon.com/iam/home#/policies/arn%3Aaws%3Aiam%3A%3Aaws%3Apolicy%2FAmazonEC2FullAccess)

WARNING: The policies above are provided to ensure a successful EC2 deployment.  It is recommended that you adjust these policies to meet the security requirements of your grid server.  They should NOT be used in a Production environment.

## Launching the EC2 instance

    $ aws ec2 run-instances --image-id ami-05fa00d4c63e32376 --instance-type t2.small --region us-east-1a --block-device-mappings file://block-device-mapping.json --user-data file://user-data.sh --associate-public-ip-address

## Logging into your server

As part of the installation process an [SSM Agent](https://docs.aws.amazon.com/systems-manager/latest/userguide/prereqs-ssm-agent.html) is added which allows you to access your server using the [Amazon EC2 Console](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-sessions-start.html#start-ec2-console).  No SSH keys, port 22 routing necessary.

### Accessing the container

    $ docker exec -it <container-id> /bin/bash

## Managing the grid server

The following command can be executed within the Docker container:

    $ service grid-server {start|stop|restart}

## Overriding grid server sources

In cases where you have an existing server set-up (e.g. configuration) follow the steps below:

### Copy the files to the container

    $ docker cp OpenSim.ini <container-id>:/usr/games/OpenSim.ini
    $ docker cp Region.ini <container-id>:/usr/games/Regions/Region.ini
    ..

### Restart the grid server

    $ docker -it <container-id> /usr/sbin/service grid-server restart

## Importing a custom database

If you have an existing database (MySQL backup `*.sql`) that you want to use, thereby overriding the installation default, you will need to manually run the server launch operations using the following workflow:

    $ docker run -d -p 9000:9000/tcp -p 9000:9000/udp --env EXTERNAL_IP=<ip-address> marcsbrooks/docker-opensimulator-server:latest sleep infinity
    $ docker cp <filename>.sql <container-id>:/tmp/opensim.sql
    $ docker exec -d <container-id> /usr/games/launch.sh

Please note the configured [OpenSim release version](http://opensimulator.org/wiki/Upgrading) since older databases may introduce backwards compatibility issues.

## Contributions

If you fix a bug, or have a code you want to contribute, please send a pull-request with your changes.

## Versioning

This package is maintained under the [Semantic Versioning](https://semver.org) guidelines.

## License and Warranty

This package is distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose.

_aws-ec2-opensimulator_ is provided under the terms of the [MIT license](http://www.opensource.org/licenses/mit-license.php)

[AWS](https://aws.amazon.com) is a registered trademark of Amazon Web Services, Inc.

## Author

[Marc S. Brooks](https://github.com/nuxy)
