import 'package:flutter/material.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final bloodType = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();

  final currentPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      // Simulate saving profile data
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم حفظ التعديلات بنجاح"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password changed successfully!")),
    );

    currentPass.clear();
    newPass.clear();
    confirmPass.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset("Image/Logo.png", height: 45),
          ),
        ),

        body: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "الملف الشخصي",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 3, 32, 61),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 242, 247, 252),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _arabicField(
                                name,
                                "الاسم الكامل (مثال: منة عاطف عبدالحميد)",
                                Icons.person,
                              ),
                              const SizedBox(height: 10),
                              _arabicField(
                                bloodType,
                                "فصيلة الدم (مثال: O+)",
                                Icons.bloodtype,
                              ),
                              const SizedBox(height: 10),
                              _arabicField(
                                phone,
                                "رقم الهاتف (مثال: 0101234567)",
                                Icons.phone,
                              ),
                              const SizedBox(height: 10),
                              _arabicField(
                                email,
                                "البريد الإلكتروني (مثال: mennaatef@gmail.com)",
                                Icons.email,
                              ),
                              const SizedBox(height: 10),
                              _arabicField(
                                address,
                                "العنوان (مثال: ارمنت الوبرات - ارمنت - الاقصر)",
                                Icons.location_on,
                              ),
                              const SizedBox(height: 20),

                              Form(
                                key: _passwordFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "تغيير كلمة المرور",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _smallPasswordField(
                                      currentPass,
                                      "كلمة المرور الحالية",
                                    ),
                                    const SizedBox(height: 8),
                                    _smallPasswordField(
                                      newPass,
                                      "كلمة المرور الجديدة",
                                    ),
                                    const SizedBox(height: 8),
                                    _smallPasswordField(
                                      confirmPass,
                                      "تأكيد كلمة المرور الجديدة",
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: changePassword,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "تغيير كلمة المرور",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                255,
                                                1,
                                                13,
                                                33,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              GestureDetector(
                                onTap: saveProfile,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "حفظ التغييرات",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 1, 13, 33),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _arabicField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
      ),
      validator: (v) => v!.trim().isEmpty ? "هذا الحقل مطلوب" : null,
    );
  }

  Widget _smallPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, size: 18),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
      ),
      style: const TextStyle(fontSize: 14),
      validator: (v) => v!.trim().isEmpty ? "هذا الحقل مطلوب" : null,
    );
  }
}
