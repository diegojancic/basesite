# LAMBDA-IMAGE VERSION:
# WORKS: 
# - zappa
# DOES NOT WORK:
# - local dev server


FROM lambci/lambda:build-python3.6

# Copy in your requirements file
ADD requirements.txt /requirements.txt
    
    
# Copy your application code to the container (make sure you create a .dockerignore file if any large files or directories should be excluded)
RUN mkdir /code/
WORKDIR /code/
ADD ./project/ /code/

ENV PS1 'zappa@$(pwd | sed "s@^/var/task/\?@@")\$ '

ENV DJANGO_SETTINGS_MODULE=root.settings

RUN virtualenv /var/venv && \
    source /var/venv/bin/activate && \
    pip install -U pip zappa && \
    pip install -r /requirements.txt 
    
USER root
    
# uWSGI will listen on this port
EXPOSE 8000

CMD source /var/venv/bin/activate && python manage.py runserver 0.0.0.0:8000

