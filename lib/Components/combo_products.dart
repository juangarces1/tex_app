import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/constans.dart';


class ComboProducts extends StatefulWidget {
  final String titulo;
  final List<Product> products;
  final Color backgroundColor;
  final  void Function(Product?) onChanged;
  
  const ComboProducts({Key? key, required this.onChanged, required this.backgroundColor, required this.products,  required this.titulo}) : super(key: key);

  @override
  State<ComboProducts> createState() => _ComboProductsState();
 }

 class _ComboProductsState extends State<ComboProducts> {
  @override
  Widget build(BuildContext context) {
   return  Container(
   padding: const EdgeInsets.all(10),
   decoration:   BoxDecoration(    
      color: widget.backgroundColor,             
      borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0))),  
   child: FindDropdown<Product>(
      showClearButton: true,
      searchBoxDecoration: const InputDecoration(
        hintText: 'Buscar'
      ),
      items: widget.products,
      label: widget.titulo,
      onFind: (String filter) => getData(filter),
      onChanged: ((selectedItem) => widget.onChanged(selectedItem)),
      dropdownBuilder: (BuildContext context, Product? item) {
        return Container(          
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color:   widget.backgroundColor,    
          ),
          child: (item?.descripcion == null)
            ?  ListTile(leading: CircleAvatar(backgroundImage:  Image.asset('assets/Icon.png').image, backgroundColor: kContrastColorMedium,), title: const Text("Seleccione un Producto..."))
            : ListTile(
                leading: CircleAvatar(backgroundImage: Image.asset('assets/Icon.png').image, backgroundColor: kContrastColorMedium,),
                subtitle:  Text(item?.medida.toString()??''),
                title: Text(item?.descripcion.toString()??''),
              ),
        );
      },
      dropdownItemBuilder: (BuildContext context, Product item, bool isSelected) {
        return Container(
          decoration: !isSelected
              ? null
              : BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
          child: ListTile(
            selected: isSelected,
            subtitle: item.descripcion == null ? const Text(''): Text(item.medida.toString()),
            title: Text(item.descripcion.toString()),
            leading: CircleAvatar(backgroundImage: Image.asset('assets/Icon.png').image, backgroundColor: kColorMyLogo,),
          ),
        );
      },
    ),
    );
  }
  

  Future<List<Product>> getData(filter) async {
     List<Product> filteredList = [];
      for (var product in widget.products) {
        if (product.descripcion!.toLowerCase().startsWith(filter)) {
          filteredList.add(product);
        }
      }
      return filteredList;
  }

  
}