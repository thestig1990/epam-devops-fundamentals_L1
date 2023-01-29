from flask import Flask, render_template
import random

# create class which allows you run webserver with port 80 by default. 
app = Flask(__name__)

# list of images
images = ["https://drive.google.com/file/d/1OTWSwKTQAnklj3LgJILUSLkimi8t6rUJ/view?usp=share_link",
    "https://drive.google.com/file/d/1aoE86fIX-5c45WOrP7IZM6Cp3yXBAqAz/view?usp=share_link",
    "https://drive.google.com/file/d/1eR1mAkcR6UxKETV0M_8MDi63CK6vV-PY/view?usp=share_link",
    "https://drive.google.com/file/d/1-r7H25mmVLDMn3JQd_ajgw6wkMT9wxyC/view?usp=share_link"
]

# create routing. after / "root" place file index.html with random image
@app.route('/')
def index():
    url = random.choice(images)   # random image
    return render_template('index.html', url=url)  # render template index.html with url


# when we launch the program as entry point. if interpretator launch program than  
if __name__ == "__main__":
    app.run(host="0.0.0.0")