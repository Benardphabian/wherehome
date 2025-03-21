import 'package:flutter/material.dart';
import 'package:wherehome/features/home_insertion/widgets/switch_buttons_rent_type.dart';

class BasicInfoStep extends StatefulWidget {
  const BasicInfoStep({super.key});

  @override
  _BasicInfoStepState createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String type = 'Rent';
  String? rentalFrequency = 'monthly';
  String? selectedCategory = 'Rental';

  final List<String> propertyCategories = [
    'Hotel', 'Rental', 'Airbnb', 'Hostel', 'Villa', 'Apartment'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Provide details to help potential renters or buyers understand your property.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 20),

              // Basic Information Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Property Title
                      _buildInputField(
                        controller: titleController,
                        label: 'Property Title',
                        hint: 'e.g., Luxurious 2-bedroom apartment',
                      ),
                      const SizedBox(height: 16),

                      // Property Category ListView
                      Text(
                        'Property Category',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50, // Adjust height for better UI
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: propertyCategories.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = propertyCategories[index];
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: selectedCategory == propertyCategories[index]
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  propertyCategories[index],
                                  style: TextStyle(
                                    color: selectedCategory == propertyCategories[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Property Type (Separate Row)
                      Text(
                        'Property Type:',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 30, // Reduced height for compact switch
                          width: MediaQuery.of(context).size.width * 0.4, // Reduced width to half
                          child: SwitchHomeType(
                            onSwitched: (String newType) {
                              setState(() {
                                type = newType;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rental Frequency (if type is Rent)
                      if (type == 'Rent') ...[
                        Text(
                          'Rental Frequency',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: rentalFrequency,
                          items: const [
                            DropdownMenuItem(value: 'daily', child: Text('Daily')),
                            DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                            DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              rentalFrequency = newValue!;
                            });
                          },
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Price Field with Ksh.
                      _buildInputField(
                        controller: priceController,
                        label: 'Price',
                        hint: 'Ksh. Enter the price',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _inputDecoration(label: label, hint: hint),
    );
  }

  // Common input decoration style
  InputDecoration _inputDecoration({String? label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
