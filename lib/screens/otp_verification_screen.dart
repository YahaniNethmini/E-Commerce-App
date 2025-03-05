import 'package:e_commerce_app/theme/theme.dart';
import 'package:e_commerce_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final int otpLength = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNode = [];

  bool _isVerifying = false;
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0; i < otpLength; i++){
      _controllers.add(TextEditingController());
      _focusNode.add(FocusNode());
    }
    _startresendTimer();
  }

  void _startresendTimer(){
    Future.delayed(
      Duration(seconds: 1),(){
        if(!mounted) return;
        setState(() {
          if(_resendTimer > 0){
            _resendTimer--;
            _startresendTimer();
          }
          else{
            _canResend = true;
          }
        });
      },
    );
  }

  void _verifyOTP(){
    String otp = _controllers.map((controller) => controller.text).join();
    if(otp.length == otpLength){
      setState(() => _isVerifying = true);
      Future.delayed(
        Duration(seconds: 2), (){
          if(!mounted) return;
        }
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNode){
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.textPrimary,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify Phone",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8),
              Text(
                "Enter 6-digit code sent to +94 77 7777 777",
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(otpLength, (index)=>SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNode[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppTheme.textSecondary.withOpacity(0.3)
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),

                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value){
                      if(value.isEmpty){
                        if(index < otpLength - 1){
                          _focusNode[index + 1].requestFocus();
                        }
                        else{
                          _focusNode[index].unfocus();
                          _verifyOTP();
                        }
                      }
                      else if(index > 0) {
                        _focusNode[index - 1].requestFocus();
                      }
                    },
                  ),
                )),
              ),
              SizedBox(height: 32),
              GradientButton(
                text: _isVerifying ? "Verifying" : "Verify",
                onPressed: (){
                  if(!_isVerifying){
                    _verifyOTP();
                  }
                },
              ),
              SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Didn't received the code",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: _canResend ? (){
                        setState(() {
                          _canResend = false;
                          _resendTimer = 30;
                        });
                        _startresendTimer();
                      } : null,
                      child: Text(
                        _canResend
                            ? "Resend Code"
                            : "Resend Code in $_resendTimer",
                        style: TextStyle(
                          color: _canResend
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
