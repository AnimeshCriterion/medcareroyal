import 'package:flutter/material.dart';

class RequestCallbackPopupStyled extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RequestCallbackFormStyled(),
                  ),
                );
              },
            );
          },
          child: Text('Request Callback'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class RequestCallbackFormStyled extends StatefulWidget {
  @override
  _RequestCallbackFormStyledState createState() =>
      _RequestCallbackFormStyledState();
}

class _RequestCallbackFormStyledState extends State<RequestCallbackFormStyled> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDoctor;
  String? _callbackTime;
  String _name = '';
  String _phoneNumber = '';
  String _reason = '';

  List<String> doctors = ['Dr. Smith', 'Dr. Brown', 'Dr. Lee'];
  List<String> timeSlots = ['Morning', 'Afternoon', 'Evening'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Request Callback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSaved: (value) {
                _name = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.phone,
              onSaved: (value) {
                _phoneNumber = value!;
              },
              validator: (value) {
                if (value!.isEmpty || value.length != 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Reason for Callback',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
              onSaved: (value) {
                _reason = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please specify the reason for callback';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Select Doctor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: doctors.map((doctor) {
                return DropdownMenuItem(
                  value: doctor,
                  child: Text(doctor),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDoctor = value as String?;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a doctor';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Preferred Callback Time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: timeSlots.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _callbackTime = value as String?;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a preferred callback time';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Logic to send callback request
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Callback requested!')),
                      );
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

