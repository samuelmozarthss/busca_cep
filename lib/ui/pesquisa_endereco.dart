import 'package:busca_cep/blocs/cep_bloc.dart';
import 'package:busca_cep/models/cep_model.dart';
import 'package:flutter/material.dart';

class PesquisaEndereco extends StatelessWidget {

  final _bloc = CepBloc();
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _textFieldController.addListener(() {
        _bloc.obterEndereco(porCep: _textFieldController.text);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Busca CEP'),
      ),
      body: SafeArea(
          child: Container(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Digite o CEP para encontrar o endereço',
                    hintText: '00000000',
                    helperText: 'somente números',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _textFieldController,
                ),

                Container(
                  child: StreamBuilder(
                    stream: _bloc.ultimoEnderecoObtido,
                    builder: (context, AsyncSnapshot<CepModel> snapshot) {
                      if (snapshot.hasData) {
                        final endereco = snapshot.data!;
                        return Column(
                          children: [
                            Text('CEP: ${endereco.cep}'),
                            Text('Logradouro: ${endereco.logradouro}'),
                            Text('Bairro: ${endereco.bairro}'),
                            Text('Cidade: ${endereco.localidade}'),
                            Text('UF: ${endereco.uf}'),
                            Text('IBGE: ${endereco.ibge}'),
                            Text('DDD: ${endereco.ddd}'),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('Ocorreu um erro!\n${snapshot.error}');
                      }

                      return  StreamBuilder(
                        stream: _bloc.carregando,
                          builder:(context, AsyncSnapshot<bool>snapshot) {
                            final carregando = snapshot.data ?? false;
                            if (carregando) {
                              return Center(child: CircularProgressIndicator());
                            }else{
                              return Container();
                            }
                          }
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

}