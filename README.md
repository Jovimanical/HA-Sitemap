# HA-Sitemap-Dev-and-Prod-Server
House Africa Development and Production Server CI/CD Automation

# kubo-core

## Development

Quick getting started tip:

cd into this project directory and run `pull-plugins && composer install`

To update the plugins from the houseafrica/kubo-plugins  and other repos run `composer update`

## Deploy to development server

Edit the changelog.md document following the convention written to update changes done
Commit changes to the main branch to trigger the CI/CD for the development server

`git branch --set-upstream-to=origin/main`
`git pull`
`git add .`
`git commit -m "developement server with XYZ updates or bugfix"`
`git push origin main`

## Deploy to production server

Edit the changelog.md document following the convention written to update changes done
Commit changes to the main branch to trigger the CI/CD for the development server

`git branch --set-upstream-to=origin/production-branch`
`git pull`
`git add .`
`git commit -m "production server with XYZ updates or bugfix"`
`git push origin production-branch`