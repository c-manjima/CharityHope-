import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hope/Admin/Admin_remove_craft.dart';
import 'package:hope/main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'Admin_Edit_craft_display_page.dart';
import 'Admin_add_craft.dart';


class Edit_craft_with_image extends StatefulWidget {
  final craft_model_Edit_display data_user;

  Edit_craft_with_image({required this.data_user});

  @override
  _Edit_craft_with_imageState createState() => _Edit_craft_with_imageState();
}

class _Edit_craft_with_imageState extends State<Edit_craft_with_image> {
  var _image;
  final picker = ImagePicker();

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController craftid = TextEditingController();
  TextEditingController description = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future choose_image_gallery() async {

    try {
      //final image = await ImagePicker.pickImage(source: ImageSource.gallery);
      final image = await picker.pickImage(source: ImageSource.gallery);


       if (image == null) return;


      final imageTemp = File(image.path);
     print(imageTemp);
      setState(() => this._image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future choose_image_camera() async {
    try {
     // final image = await ImagePicker.pickImage(source: ImageSource.camera);
      final image = await picker.pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this._image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future updateImage() async {
    final uri = Uri.parse(
        "http://$ip_address/charity_hope/admin/admin_craftt_edit.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] =  widget.data_user.id.toString();
    request.fields['price'] = price.text;
    request.fields['name'] = name.text;
    request.fields['craft_id'] = craftid.text;
    request.fields['description'] = description.text;
    print(request.fields['name']);
    if(_image!=null)
    {
      var pic = await http.MultipartFile.fromPath("image", _image.path);
      // var pic = await http.MultipartFile.fromPath("image", _image.path);
      print("**********************************");
      print(_image);
      request.files.add(pic);
    }
    var response = await request.send();
    print(response);

    if (response.statusCode == 200) {
      print('Image Uploded');
      price.clear();
      name.clear();
      description.clear();
      craftid.clear();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin_Edit_craft_Display_page()));


      final snackBar = await SnackBar(
        content: const Text('Updated Successfully!'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            //Navigator.pop(context);
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print('Image Not Uploded');
    }
    setState(() {});
  }
@override
  void initState() {

  name = TextEditingController(text: widget.data_user.name);
  price = TextEditingController(text: widget.data_user.price);
  craftid = TextEditingController(text: widget.data_user.craftid);
  description = TextEditingController(text: widget.data_user.description);



    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add craft shop item",
          style: GoogleFonts.prompt(color: Colors.white),
        ),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded, color: Colors.white,
            size: 35, // add custom icons also
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
SizedBox(height: 70,),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: TextFormField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "enter craft name",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: TextFormField(
                  controller: price,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Enter price",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Choose Image",
                    style: GoogleFonts.hindVadodara(
                      fontSize: 20,
                      color: Colors.purpleAccent.shade100,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.photo_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      choose_image_gallery();

                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      choose_image_camera();
                    },
                  ),
                ],
              ),
              Center(
                child: Container(
                    height: 100,
                    width: 200,
                    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),  color: Colors.grey,
                    //),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: _image != null
                          ?
                        Image.file(
                        _image,
                        fit: BoxFit.cover,
                      )

                          : Image.network(widget.data_user.image,
                         fit: BoxFit.cover ,
                      ),

                    )
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.purpleAccent,
                  padding: EdgeInsets.only(
                      left: 110, right: 110, top: 20, bottom: 20),
                ),
                onPressed: () {
                  setState(() {});
                  updateImage();
                 
                },
                child: Text('Update'),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
