import 'dart:collection';
import 'dart:io';
import 'antrian.dart';
class Customer {
  String name;
  int accountNumber;
  double balance;
  String pin;
  Customer(this.name, this.accountNumber, this.balance, this.pin);
}
class Bank {
  List<Customer> customers = [];
  Queue<Customer> customerQueue = Queue<Customer>();
  QueueSystem queueSystem = QueueSystem();
  int nextAccountNumber = 1;

  void openNewAccount(String name, String pin, String confirmPin) {
    if (pin == confirmPin) {
      customers.add(Customer(name, nextAccountNumber++, 0.0, pin));
      print(
          "Account opened for $name with account number ${nextAccountNumber - 1}");
    } else {
      print("PIN and confirmation PIN do not match.");
    }
  }
  void deposit(int accountNumber, double amount, String pin) {
    var customer = customers.firstWhere(
        (customer) => customer.accountNumber == accountNumber,
        orElse: () => Customer('Invalid', 0, 0.0, ''));
    if (customer.accountNumber != 0) {
      if (customer.pin == pin) {
        customer.balance += amount;
        print(
            "Deposited Rp${amount.toStringAsFixed(2)} to account number $accountNumber. New balance: Rp${customer.balance.toStringAsFixed(2)}");
      } else {
        print("Invalid PIN.");
      }
    } else {
      print("Account number $accountNumber not found.");
    }
  }
  void withdraw(int accountNumber, double amount, String pin) {
    var customer = customers.firstWhere(
        (customer) => customer.accountNumber == accountNumber,
        orElse: () => Customer('Invalid', 0, 0.0, ''));
    if (customer.accountNumber != 0) {
      if (customer.pin == pin) {
        if (customer.balance >= amount) {
          customer.balance -= amount;
          print(
              "Withdrew Rp${amount.toStringAsFixed(2)} from account number $accountNumber. New balance: Rp${customer.balance.toStringAsFixed(2)}");
        } else {
          print("Insufficient balance.");
        }
      } else {
        print("Invalid PIN.");
      }
    } else {
      print("Account number $accountNumber not found.");
    }
  }
  void addToQueue(String name) {
    var customer = customers.firstWhere((customer) => customer.name == name,
        orElse: () => Customer('Invalid', 0, 0.0, ''));
    if (customer.accountNumber != 0) {
      customerQueue.addLast(customer);
      queueSystem.addNewNumber();
      print("$name added to the queue.");
    } else {
      print("Customer $name not found.");
    }
  }
  void serveNextCustomer() {
    if (customerQueue.isNotEmpty) {
      var customer = customerQueue.removeFirst();
      queueSystem.callNextNumber();
      print(
          "Serving ${customer.name} with account number ${customer.accountNumber}");
    } else {
      print("No customers in the queue.");
    }
  }
  void showCustomers() {
    customers.sort((a, b) => a.name.compareTo(b.name));
    for (var customer in customers) {
      print(
          "Name: ${customer.name}, Account Number: ${customer.accountNumber}, Balance: Rp${customer.balance.toStringAsFixed(2)}");
    }
  }
  void checkBalance(int accountNumber) {
    var customer = customers.firstWhere(
        (customer) => customer.accountNumber == accountNumber,
        orElse: () => Customer('Invalid', 0, 0.0, ''));
    if (customer.accountNumber != 0) {
      print("Balance for account number $accountNumber: Rp${customer.balance.toStringAsFixed(2)}");
    } else {
      print("Account number $accountNumber not found.");
    }
  }
  void changeCustomerDetails(int accountNumber) {
    var customer = customers.firstWhere(
        (customer) => customer.accountNumber == accountNumber,
        orElse: () => Customer('Invalid', 0, 0.0, ''));
    if (customer.accountNumber != 0) {
      while (true) {
        print("\nCustomer Service Menu:");
        print("1. Rubah PIN");
        print("2. Rubah No Rekening");
        print("3. Rubah Nama Nasabah");
        print("4. Kembali ke Menu Utama");
        stdout.write("Pilih menu: ");
        var choice = stdin.readLineSync();
        switch (choice) {
          case '1':
            stdout.write("Masukkan PIN baru: ");
            var newPin = stdin.readLineSync()!;
            customer.pin = newPin;
            print("PIN changed successfully.");
            break;
          case '2':
            stdout.write("Masukkan nomor rekening baru: ");
            var newAccountNumber = int.parse(stdin.readLineSync()!);
            customer.accountNumber = newAccountNumber;
            print("Account number changed successfully to $newAccountNumber.");
            break;
          case '3':
            stdout.write("Masukkan nama baru: ");
            var newName = stdin.readLineSync()!;
            customer.name = newName;
            print("Name changed successfully to $newName.");
            break;
          case '4':
            return;
          default:
            print("Pilihan tidak valid.");
        }
      }
    } else {
      print("Customer with account number $accountNumber not found.");
    }
  }
}
void main() {
  var bank = Bank();
  while (true) {
    print("\nBank Menu:");
    print("1. Buka Rekening Baru");
    print("2. Setor");
    print("3. Tarik");
    print("4. Layanan Customer Service");
    print("5. Tambahkan Nasabah ke Antrian");
    print("6. Layani Nasabah Berikutnya");
    print("7. Tampilkan Daftar Nasabah");
    print("8. Cek Saldo");
    print("9. Keluar");
    stdout.write("Pilih menu: ");
    var bankChoice = stdin.readLineSync();
    switch (bankChoice) {
      case '1':
        stdout.write("Masukkan nama nasabah: ");
        var name = stdin.readLineSync()!;
        stdout.write("Masukkan PIN: ");
        var pin = stdin.readLineSync()!;
        stdout.write("Konfirmasi PIN: ");
        var confirmPin = stdin.readLineSync()!;
        bank.openNewAccount(name, pin, confirmPin);
        break;
      case '2':
        stdout.write("Masukkan nomor rekening: ");
        var accountNumber = int.parse(stdin.readLineSync()!);
        stdout.write("Masukkan jumlah setoran: ");
        var amount = double.parse(stdin.readLineSync()!);
        stdout.write("Masukkan PIN: ");
        var pin = stdin.readLineSync()!;
        bank.deposit(accountNumber, amount, pin);
        break;
      case '3':
        stdout.write("Masukkan nomor rekening: ");
        var accountNumber = int.parse(stdin.readLineSync()!);
        stdout.write("Masukkan jumlah penarikan: ");
        var amount = double.parse(stdin.readLineSync()!);
        stdout.write("Masukkan PIN: ");
        var pin = stdin.readLineSync()!;
        bank.withdraw(accountNumber, amount, pin);
        break;
      case '4':
        stdout.write("Masukkan nomor rekening: ");
        var accountNumber = int.parse(stdin.readLineSync()!);
        bank.changeCustomerDetails(accountNumber);
        break;
      case '5':
        stdout.write("Masukkan nama nasabah: ");
        var name = stdin.readLineSync()!;
        bank.addToQueue(name);
        break;
      case '6':
        bank.serveNextCustomer();
        break;
      case '7':
        bank.showCustomers();
        break;
      case '8':
        stdout.write("Masukkan nomor rekening: ");
        var accountNumber = int.parse(stdin.readLineSync()!);
        bank.checkBalance(accountNumber);
        break;
      case '9':
        exit(0);
      default:
        print("Pilihan tidak valid.");
    }
  }
}