## Running locally

### Prerequisites

The following software needs to be preinstalled

* Node.js 6+
* RabbitMQ 3.6+

### Languages

The following languages and conventions are used in this project

* FBP - Flow based Programming Paradigm
* Coffee Script - Transpiler to convert to Javascript

### Project Structure
* graphs - Directory holds all the graphs and subgraphs related to koreflow engine
* components - Contains Noflo components used to create NoFlo Graphs (as Msgflo Participant)
* participants - Contains different Msgflo Participants that will be used to design various workflow    
                 usecases
* src - Application Source Code
* index.js - Index file
* package.json - Dependency management'''


### Download git repo

    git clone https://github.com/koredotcom/msgflo-koreflow.git
    cd msgflo-koreflow

### Install

    npm install
    
### Configure

* source ./setenv.sh
(or)
* export KOREFLOW_HOME="home/srinivasapuranam/git_workspace/msgflo-koreflow"
* export MSGFLO_BROKER="amqp://guest:guest@localhost:5672"
* export PATH=$KOREFLOW_HOME/node_modules/.bin:$PATH
* export DEBUG=*

### Run

* Run the entire service

    node index.js

* Run the KoreFlow Graph

    msgflo --ide http://localhost:9911 --graph graphs/kflow.fbp

* Run the Noflo Graph as Participant

    noflo-runtime-msgflo --name newprocess --graph msgflo-example-imageresize/newprocess

* Run NoFlo IDE locally to visualize your graphs

    Follow this: https://github.com/noflo/noflo-ui
