import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:tex_app/Models/category.dart';
import 'package:tex_app/constans.dart';

class ComboCategorias extends StatefulWidget {
  final String titulo;
  final List<Category> categories;
  final Color backgroundColor;
  final  void Function(Category?) onChanged;
  const ComboCategorias({Key? key, required this.onChanged, required this.backgroundColor, required this.categories,  required this.titulo}) : super(key: key);

  @override
  State<ComboCategorias> createState() => _ComboCategoriasState();
}

class _ComboCategoriasState extends State<ComboCategorias> {
  @override
  Widget build(BuildContext context) {
    return  Container(
   padding: const EdgeInsets.all(10),
   decoration:   BoxDecoration(    
      color: widget.backgroundColor,             
      borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0))),  
   child: FindDropdown<Category>(
      showClearButton: true,
      searchBoxDecoration: const InputDecoration(
        hintText: 'Buscar'
      ),
      items: widget.categories,
      label: widget.titulo,
      onFind: (String filter) => getData(filter),
      onChanged: ((selectedItem) => widget.onChanged(selectedItem)),
      dropdownBuilder: (BuildContext context, Category? item) {
        return Container(          
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color:   widget.backgroundColor,    
          ),
          child: (item?.name == null)
            ?  ListTile(leading: CircleAvatar(backgroundImage:  Image.asset('assets/Icon.png').image, backgroundColor: kContrastColorMedium,), title: const Text("Seleccione una Categoria..."))
            : ListTile(
                leading: CircleAvatar(backgroundImage: Image.asset('assets/Icon.png').image, backgroundColor: kContrastColorMedium,),               
                title: Text(item?.name.toString()??''),
              ),
        );
      },
      dropdownItemBuilder: (BuildContext context, Category item, bool isSelected) {
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
            title: Text(item.name.toString()),
            leading: CircleAvatar(backgroundImage: Image.asset('assets/Icon.png').image, backgroundColor: kColorMyLogo,),
          ),
        );
      },
    ),
    );
  }
  

  Future<List<Category>> getData(filter) async {
     List<Category> filteredList = [];
      for (var product in widget.categories) {
        if (product.name!.toLowerCase().startsWith(filter)) {
          filteredList.add(product);
        }
      }
      return filteredList;
  }
}