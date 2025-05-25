import 'package:flutter/material.dart';

void main() => runApp(ProdutoApp());

class Produto {
  String nome;
  double precoCompra;
  double precoVenda;
  int quantidade;
  String descricao;
  String categoria;
  String imagemUrl;
  bool ativo;
  bool promocao;
  double desconto;

  Produto({
    required this.nome,
    required this.precoCompra,
    required this.precoVenda,
    required this.quantidade,
    required this.descricao,
    required this.categoria,
    required this.imagemUrl,
    required this.ativo,
    required this.promocao,
    required this.desconto,
  });
}

class ProdutoApp extends StatefulWidget {
  @override
  _ProdutoAppState createState() => _ProdutoAppState();
}

class _ProdutoAppState extends State<ProdutoApp> {
  final List<Produto> _produtos = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Produtos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CadastroProdutoScreen(onCadastrar: (produto) {
        setState(() => _produtos.add(produto));
      }, produtos: _produtos),
    );
  }
}

class CadastroProdutoScreen extends StatefulWidget {
  final void Function(Produto) onCadastrar;
  final List<Produto> produtos;

  CadastroProdutoScreen({required this.onCadastrar, required this.produtos});

  @override
  _CadastroProdutoScreenState createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  String nome = '', descricao = '', categoria = '', imagemUrl = '';
  double precoCompra = 0, precoVenda = 0, desconto = 0;
  int quantidade = 0;
  bool ativo = false, promocao = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
                onSaved: (value) => nome = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço de compra'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe o preço de compra' : null,
                onSaved: (value) => precoCompra = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço de venda'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe o preço de venda' : null,
                onSaved: (value) => precoVenda = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe a quantidade' : null,
                onSaved: (value) => quantidade = int.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
                onSaved: (value) => descricao = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Categoria'),
                onSaved: (value) => categoria = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Imagem (URL)'),
                onSaved: (value) => imagemUrl = value ?? '',
              ),
              SwitchListTile(
                title: Text('Produto Ativo'),
                value: ativo,
                onChanged: (val) => setState(() => ativo = val),
              ),
              CheckboxListTile(
                title: Text('Em Promoção'),
                value: promocao,
                onChanged: (val) => setState(() => promocao = val!),
              ),
              Text('Desconto (%)'),
              Slider(
                value: desconto,
                min: 0,
                max: 100,
                divisions: 20,
                label: desconto.toStringAsFixed(0),
                onChanged: (val) => setState(() => desconto = val),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Produto p = Produto(
                      nome: nome,
                      precoCompra: precoCompra,
                      precoVenda: precoVenda,
                      quantidade: quantidade,
                      descricao: descricao,
                      categoria: categoria,
                      imagemUrl: imagemUrl,
                      ativo: ativo,
                      promocao: promocao,
                      desconto: desconto,
                    );
                    widget.onCadastrar(p);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListaProdutosScreen(produtos: widget.produtos),
                      ),
                    );
                  }
                },
                child: Text('Cadastrar Produto'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListaProdutosScreen extends StatelessWidget {
  final List<Produto> produtos;

  ListaProdutosScreen({required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Produtos')),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final p = produtos[index];
          return ListTile(
            leading: Image.network(p.imagemUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.broken_image)),
            title: Text(p.nome),
            subtitle: Text('R\$ ${p.precoVenda.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalhesProdutoScreen(produto: p),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetalhesProdutoScreen extends StatelessWidget {
  final Produto produto;

  DetalhesProdutoScreen({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.network(produto.imagemUrl, height: 200, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 200)),
            SizedBox(height: 10),
            Text(produto.nome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Preço de Compra: R\$ ${produto.precoCompra.toStringAsFixed(2)}'),
            Text('Preço de Venda: R\$ ${produto.precoVenda.toStringAsFixed(2)}'),
            Text('Quantidade: ${produto.quantidade}'),
            Text('Descrição: ${produto.descricao}'),
            Text('Categoria: ${produto.categoria}'),
            Row(
              children: [
                Icon(produto.ativo ? Icons.check_circle : Icons.cancel, color: produto.ativo ? Colors.green : Colors.red),
                SizedBox(width: 8),
                Text(produto.ativo ? 'Ativo' : 'Inativo'),
              ],
            ),
            Row(
              children: [
                Icon(produto.promocao ? Icons.local_offer : Icons.remove, color: produto.promocao ? Colors.orange : Colors.grey),
                SizedBox(width: 8),
                Text(produto.promocao ? 'Em Promoção' : 'Sem Promoção'),
              ],
            ),
            Text('Desconto: ${produto.desconto.toStringAsFixed(0)}%'),
          ],
        ),
      ),
    );
  }
}
