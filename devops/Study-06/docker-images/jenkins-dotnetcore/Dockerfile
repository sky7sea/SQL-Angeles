FROM jenkins/jenkins:lts
# if we want to install via apt
USER root

RUN apt-get update
RUN apt-get install apt-transport-https -y

RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN wget -q https://packages.microsoft.com/config/debian/9/prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list
RUN apt-get update
# RUN apt-get install aspnetcore-runtime-2.1 -y
RUN apt-get install dotnet-sdk-2.1.202 -y
# drop back to the regular jenkins user - good practice
USER jenkins

# docker build . -t jenkins-dotnetcore