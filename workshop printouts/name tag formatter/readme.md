# Name tag formatter readme

This simple `jspdf.html` script will ingest a CSV with participants' information and output a PDF suitable for printing nametags onto a sheet of ten 4" x 2" labels. (We use [these fluorescent labels](https://www.amazon.com/dp/B096L7YMBV) from Amazon.)

The script will use only the following columns from the input CSV (case sensitive):
* First Name
* Last Name
* School
* Team

The output labels print the participant's first name bold and centered, then last name in a smaller font below that; the name of their school; a blank prompt in the lower left reading "Favorite tool: ______________", and finally their team name/number in the lower right.

The script was developed with ChatGPT.