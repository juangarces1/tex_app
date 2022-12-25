import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:tex_app/Models/supplier.dart';
import 'package:tex_app/constans.dart';

class ComboSuplliers extends StatefulWidget {
  const ComboSuplliers({Key? key, required this.onChanged, required this.backgroundColor, required this.suppliers,  required this.titulo}) : super(key: key);
  
  final String titulo;
  final List<Supplier> suppliers;
  final Color backgroundColor;
  final  void Function(Supplier?) onChanged;

  @override
  State<ComboSuplliers> createState() => _ComboSuplliersState();
}

class _ComboSuplliersState extends State<ComboSuplliers> {
  @override
  Widget build(BuildContext context) {
    return   Container(
   padding: const EdgeInsets.all(10),
   decoration:   BoxDecoration(    
      color: widget.backgroundColor,             
      borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0))),  
   child: FindDropdown<Supplier>(
      showClearButton: true,
      searchBoxDecoration: const InputDecoration(
        hintText: 'Buscar'
      ),
      items: widget.suppliers,
      label: widget.titulo,
      onFind: (String filter) => getData(filter),
      onChanged: ((selectedItem) => widget.onChanged(selectedItem)),
      dropdownBuilder: (BuildContext context, Supplier? item) {
        return Container(          
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color:   widget.backgroundColor,    
          ),
          child: (item?.name == null)
            ?  ListTile(leading: CircleAvatar(backgroundImage:  Image.asset('assets/prove.png').image, backgroundColor: kContrastColorMedium,), title: const Text("Seleccione Un Proveedor..."))
            : ListTile(
                leading: CircleAvatar(backgroundImage: Image.asset('assets/prove.png').image, backgroundColor: kContrastColorMedium,),              
                title: Text(item?.name.toString()??''),
                subtitle: Text(item?.lastName.toString()??''),
              ),
        );
      },
      dropdownItemBuilder: (BuildContext context, Supplier item, bool isSelected) {
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
            subtitle: Text(item.lastName.toString()),
            leading: CircleAvatar(backgroundImage: Image.asset('assets/prove.png').image, backgroundColor: kColorMyLogo,),
          ),
          );
        },
      ),
    );
  }

   Future<List<Supplier>> getData(filter) async {
     List<Supplier> filteredList = [];
      for (var sup in widget.suppliers) {
        if (sup.name!.toLowerCase().startsWith(filter)) {
          filteredList.add(sup);
        }
      }
      return filteredList;
  }
}