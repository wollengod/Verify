import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:verify/utilities/hex_color.dart';

import 'changing_pass.dart';
class Otp extends StatefulWidget {
  final String number;
  final String sessionId;

  const Otp({super.key, required this.number, required this.sessionId});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String _otp = "";
  void verifyOTP() async {
    final apiKey = "ceabde09-483f-11f0-a562-0200cd936042";
    final url = Uri.parse(
        "https://2factor.in/API/V1/$apiKey/SMS/VERIFY/${widget.sessionId}/$_otp"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Password()),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully Verified')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    return SafeArea(
        child: Scaffold(
            backgroundColor: "#001234".toColor(),
            body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  child:
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                         Text('Verification Code',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                        const SizedBox(height: 20,),
                         Text('Enter the verification code that we send on mobile after confirmation you can reset your password',style: TextStyle(fontSize: 18,color: Colors.white),),
                        const SizedBox(height: 100,),
                        Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Pinput(
                                length: 6,
                                onChanged: (value) => _otp = value,
                                onCompleted: (value) => _otp = value,
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  Text('Resend OTP',style: TextStyle(color: Colors.grey.shade700),),
                                ],
                              ),
                              const SizedBox(height: 40,),
                              ElevatedButton(onPressed: (){
                                if(_formkey.currentState!.validate()){
                                  verifyOTP();
                                }
                                else{
                                  print('Not working');
                                }
                              },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  backgroundColor: Theme.of(context).textTheme.bodyMedium!.color,
                                ),
                                child: const Text('Confirm',),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                )
            )
        ));
  }
}
