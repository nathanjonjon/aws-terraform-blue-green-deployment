# Blue/Green Deployment

This is a DevOps project based on `aws` and `terraform` that f staging on demand and blue-green deployment upon change in master branch of a Github repository

## Project Structure

![](https://github.com/nathanjonjon/aws-terraform-blue-green/blob/main/architecture.png)

### AWS CodePipeline, AWS CodeBuild 
CI/CD pipeline that consists of four parts:
1. Source
    Listen to changes of given branch
2. Build
    docker build and docker push to ECR
3. Test
    Create a staging env and run the service
4. Deploy
    Create production env and start blue/green deployment

### Application Load Balancer, Target Group, Auto-scaling Group, Launch Configuration
1. Bootstrap by configurating and maintaining these AWS cloud infrastructure (blue infra) manaully.
2. Application Load Balancer listens to two target groups for blue/green infra, and use Terraform to launch and destroy auto-scaling group that attaches to each target group.
3. Customize the settings of auto-scaling group, launch config in `.tf`

### Terrafrom
1. Create staging instance and run the service
2. Destroy staging instance upon approval
3. Create green infrastructure
4. Reroute traffic to green when all green targets are healthy
5. Import existing blue infra and destroy them
6. Create new blue infrastructure
7. Reroute traffic to new blue infra, and destroy green infra when all blue targets are healthy
