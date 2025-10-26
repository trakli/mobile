import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoInterface extends StatelessWidget {
  const InfoInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Section
              CircleAvatar(
                radius: 32.sp,
                backgroundColor: const Color(0xFFE8F5E9),
                child: Icon(
                  Icons.label_outline,
                  size: 36.sp,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                "Organize Your Money with Categories",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10.sp),

              // Subtitle
              Text(
                "Categories help you understand where your money comes from and where it goes. Let's start with some basics!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.sp),

              // Quick Start Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.sp),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "QUICK START:",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    _buildStep("1",
                        "Create income categories (e.g., 'Salary', 'Freelance')"),
                    SizedBox(height: 8.sp),
                    _buildStep("2",
                        "Add expense categories (e.g., 'Food', 'Transport')"),
                    SizedBox(height: 8.sp),
                    _buildStep("3", "Use them when adding transactions"),
                  ],
                ),
              ),

              SizedBox(height: 28.sp),

              // Button
              SizedBox(
                width: double.infinity,
                height: 48.sp,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to Add Category Screen
                  },
                  icon: const Icon(Icons.add),
                  label: Text(
                    "Add First Category",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.sp),

              // Tip box
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: const Color(0xFFFFA000), size: 20.sp),
                    SizedBox(width: 8.sp),
                    Expanded(
                      child: Text(
                        "Don't worry about getting it perfect — you can always add more categories later!",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.brown[700],
                          height: 1.4,
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

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12.sp,
          backgroundColor: const Color(0xFF2E7D32),
          child: Text(
            number,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 8.sp),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
