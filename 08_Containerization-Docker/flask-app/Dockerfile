# Launches Alpine OS, installs python3 in it and runs the app.py 
# after the container startup

# this is base image
FROM alpine:3.15

# Install python and pip
RUN apk add --update python3
RUN apk add --update py3-pip

# Install Python modules needed by Python app
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

# copy files required for the app to run
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/

# tell the port number the container should expose
EXPOSE 5000

# run the applicaton
CMD ["python3", "/usr/src/app/app.py"]