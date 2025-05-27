import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:tech_challenge_3/common/bloc/button/button_state.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state_cubit.dart';
import 'package:tech_challenge_3/common/widgets/button/basic_app_button.dart';
import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';
import 'package:tech_challenge_3/domain/usecases/transactions/create_transaction.dart';
import 'package:tech_challenge_3/service_locator.dart';
import 'package:tech_challenge_3/utils/currency_formatter.dart';

class CreateTransactionPage extends StatefulWidget {
  static const String routeName = '/add-transaction';

  const CreateTransactionPage({super.key});

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  TransactionType? _selectedType;
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.appTheme.primaryColor,
              onPrimary: Colors.white,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitTransaction(BuildContext blocContext) {
    if (_formKey.currentState!.validate()) {
      if (_selectedType == null) {
        ScaffoldMessenger.of(blocContext).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione o tipo de transação.'),
          ),
        );
        return;
      }

      final amountText = _amountController.text.replaceAll(',', '.');
      final amount = double.tryParse(amountText);

      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(blocContext).showSnackBar(
          const SnackBar(content: Text('Valor inválido ou não positivo.')),
        );
        return;
      }

      final transactionDto = TransactionCreateDto(
        type: _selectedType!,
        description: _descriptionController.text,
        amount: amount,
        date: _selectedDate,
      );

      blocContext.read<ButtonStateCubit>().excute(
        usecase: sl<CreateTransactionUseCase>(),
        params: transactionDto,
      );
    } else {
      ScaffoldMessenger.of(blocContext).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos corretamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Nova transação',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.appTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transação criada com sucesso!')),
              );
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
            if (state is ButtonFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Erro ao criar transação: ${state.errorMessage}',
                  ),
                ),
              );
            }
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/pixels_top.svg',
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/pixels_bottom.svg',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                height: 150,
                child: SvgPicture.asset(
                  'assets/images/woman.svg',
                  fit: BoxFit.contain,
                ),
              ),
              SafeArea(
                minimum: const EdgeInsets.only(top: 10, right: 16, left: 16),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ), // Reduzido para compensar SafeArea.minimum
                        _buildDropdownType(),
                        const SizedBox(height: 20),
                        _buildDescriptionField(),
                        const SizedBox(height: 20),
                        _buildAmountField(),
                        const SizedBox(height: 20),
                        _buildDateField(context),
                        const SizedBox(height: 30),
                        _buildSubmitButton(), // O botão agora usa BlocBuilder
                        const SizedBox(
                          height: 180,
                        ), // Espaço para a imagem da mulher
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownType() {
    return DropdownButtonFormField<TransactionType>(
      value: _selectedType,
      decoration: _inputDecoration('Selecione o tipo de transação'),
      hint: const Text('Tipo de transação'),
      items:
          TransactionType.values.map((TransactionType type) {
            return DropdownMenuItem<TransactionType>(
              value: type,
              child: Text(transactionTypeToString(type)),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
      validator: (value) => value == null ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: _inputDecoration('Descrição'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira uma descrição.';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    final CurrencyTextInputFormatter _currencyFormatter =
        CurrencyTextInputFormatter();

    return TextFormField(
      controller: _amountController,
      decoration: _inputDecoration(
        'Valor (Ex: 150,00)',
        prefixText: 'R\$ ',
        hintText: '0,00',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [_currencyFormatter],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira um valor.';
        }
        final number = double.tryParse(value.replaceAll(',', '.'));
        if (number == null || number <= 0) {
          return 'Por favor, insira um valor válido e maior que zero.';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _pickDate(context),
      child: InputDecorator(
        decoration: _inputDecoration('Data da Transação'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
            Icon(Icons.calendar_today, color: AppTheme.appTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        if (state is ButtonLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.appTheme.primaryColor,
            ),
          );
        }
        return BasicAppButton(
          title: 'Concluir transação',
          backgroundColor: AppTheme.appTheme.primaryColor,
          textColor: Colors.white,
          onPressed:
              () =>
                  _submitTransaction(context), // Passa o context do BlocBuilder
        );
      },
    );
  }

  InputDecoration _inputDecoration(
    String labelText, {
    String? prefixText,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hint:
          hintText != null
              ? Text(hintText, style: TextStyle(fontSize: 16))
              : null,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppTheme.appTheme.indicatorColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppTheme.appTheme.indicatorColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: AppTheme.appTheme.primaryColor, width: 2),
      ),
      labelStyle: TextStyle(
        color: AppTheme.appTheme.primaryColor.withOpacity(0.9),
      ),
    );
  }
}
