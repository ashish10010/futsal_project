import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/field_cubit.dart';

import '../widgets/futsal_field_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //fetch data when homepage is initialized,
    context.read<FieldCubit>().fetchFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              _searchSection(),
              const SizedBox(
                height: 12,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: Text(
                  "Explore Available Futsal Fields", // Add your text here
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<FieldCubit, FieldState>(
                builder: (context, state) {
                  if (state is FieldLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is FieldSuccess) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.fields.length,
                      itemBuilder: (context, index) {
                        final field = state.fields[index];
                        return FutsalFieldCard(
                          fields: field, // Pass the entire FieldModel object
                        );
                      },
                    );
                  } else if (state is FieldFailure) {
                    return Center(
                      child: Text("Error: ${state.error}"),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image_profile.png"),
              ),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, User",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on, size: 15),
                  SizedBox(width: 4),
                  Text(
                    "Pokhara-16",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          const Icon(Icons.notifications),
        ],
      ),
    );
  }

  Widget _searchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Where would you like\nto play futsal?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Search futsal fields...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
