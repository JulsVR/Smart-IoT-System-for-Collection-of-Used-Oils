# Smart IoT System for Collection of Used Cooking Oil (UCO)

Developed as the final project of the Bachelor Degree, this project consists of building a prototype for data collection of multiple samples of different percentages of water in used cooking oil.
Data collected will later be used for training and testing a ML algorithm so that it can detect any oil "contaminated" by water.

## **Grade: 17/20**


### Description 
Development of a smart IoT system, combining Edge+Fog+Cloud computing concepts in an architecture to manage the distributed collection of UCOs (used cooking oils) that are later directed towards recycling and biodiesel production.
A UCO collection prototype will be fitted with an ESP32 microcontroller and various sensors (temperature, flow, level, turbidity) to collect some of the properties of the deposited liquids. The collected information will be processed and sent via HTTP requests to a local devicde (RaspberryPi) to be stored and processed in a docker container running PostgreSQL. The collected information is sent via API requests to a Cloud server which presents the information graphically.
Furthermore, the data collected is used for training and testing a ML algorithm so that it can detect any oil "contaminated" by water. 
Said algorithm would later be implemented in a network of oil tanks that are spread throughout the country, for any citizen to deposit their used cooking oil. 

#### The prototype created

![IMG_20230518_153310](https://github.com/osvaldodmvs/LPI/assets/90912624/08d0db3a-fd8c-40d0-ba5a-16d9ab092160) ![IMG_20230518_153336](https://github.com/osvaldodmvs/LPI/assets/90912624/20ae9d12-85f9-4a0b-a1f7-b1e66f1e9b12)

#### Example of one of the processes of data collection and their results

https://github.com/osvaldodmvs/LPI/assets/90912624/5f4edf8f-f8e7-45c1-961e-fbb438d21d3d

