import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cubit/field_cubit.dart';
import '../../../core/widgets/futsal_field_card.dart';
import '../../../core/constants/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch fields when the homepage is initialized
    context.read<FieldCubit>().fetchAllFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QuickSal",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Palette.primaryGreen,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _headerSection(),
            const SizedBox(height: 10),
            _searchBar(),
            const SizedBox(height: 20),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Explore Futsal Fields",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<FieldCubit, FieldState>(
                builder: (context, state) {
                  if (state is FieldLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is FieldSuccess) {
                    return ListView.builder(
                      itemCount: state.fields.length,
                      itemBuilder: (context, index) {
                        final field = state.fields[index];
                        return FutsalFieldCard(fields: field);
                      },
                    );
                  } else if (state is FieldFailure) {
                    return Center(
                      child: Text(
                        "Error: ${state.error}",
                        style: const TextStyle(color: Palette.error),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/abc_futsal2.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              "Welcome to QuickSal",
              style: headlineTextStyle.copyWith(
                color: Palette.white,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search futsal fields...",
          hintStyle: bodyTextStyle.copyWith(color: Palette.grey),
          prefixIcon: const Icon(Icons.search, color: Palette.primaryGreen),
          filled: true,
          fillColor: Palette.lightGreen.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
