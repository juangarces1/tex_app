import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:tex_app/Models/product.dart';
import 'package:tex_app/constans.dart';

class ComboColores extends StatefulWidget {
  final String titulo;
  final List<Product> products;
  final Color backgroundColor;
  final  void Function(Product?) onChanged;
  const ComboColores({Key? key, required this.onChanged, required this.backgroundColor, required this.products,  required this.titulo}) : super(key: key);

  @override
  State<ComboColores> createState() => _ComboColoresState();
}

class _ComboColoresState extends State<ComboColores> {
  @override
  Widget build(BuildContext context) {
    return   Container(
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
            ?  ListTile(leading: CircleAvatar(backgroundImage:  Image.asset('assets/Icon.png').image, backgroundColor: kContrastColorMedium,), title: const Text("Seleccione Un Color..."))
            : ListTile(
                leading: CircleAvatar(backgroundImage: Image.asset('assets/Icon.png').image, backgroundColor: kContrastColorMedium,),              
                title: Text(item?.color.toString()??''),
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
            title: Text(item.color.toString()),
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
        if (product.color!.toLowerCase().startsWith(filter)) {
          filteredList.add(product);
        }
      }
      return filteredList;
  }
}