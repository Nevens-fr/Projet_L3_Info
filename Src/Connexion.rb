##
# Ecran qui permet à l'utilisateur de se connecter à ses sauvegardes

class Connexion

    def Connexion.creer(win)
        new(win)
    end

    private_class_method :new

    def initialize(win)

        @win = win
        @win.set_title("Connexion")
        @win.set_default_size(600, 600)

        boite = Gtk::Fixed.new()
        @layoutManager = Gtk::Box.new(:vertical)

        boite.add(Gtk::Image.new(:file => "../maquettes/texture_liege.jpg"))

        @layoutManager.add(boite)
        @win.add(@layoutManager)

        saisie = Gtk::Entry.new()
        valider = Gtk::Button.new(:label => "Valider")
        choixExistant = Gtk::ComboBoxText.new

        choixExistant.append_text "Sélectionner votre session"
        choixExistant.active= 0

        chargerExistants(choixExistant)##### CHARGER LES USERS EXISTANTS

        valider.signal_connect("clicked"){
            if saisie.text.length == 0
                if choixExistant.active != 0
                    $userPath += choixExistant.active_text
                    vers_menu()
                end
            else
                File.open($userPath + "users.txt", "w")
                File.write($userPath + "users.txt", saisie.text+"\n", mode: "a")
                $userPath += saisie.text
                vers_menu()
            end
        }

        widthEcran = 600
        heightEcran = 600

        css = Gtk::CssProvider.new
        css.load(data: <<-CSS)
            button {
                opacity: 0.5;
                border: unset;
                color: black;
            }
            button:hover {
                opacity: 0.8;
                border: 1px solid black;
            }
        CSS


        ajoutecssProvider(valider, css, 120, 50)

        
        boite.put(valider, (widthEcran *0.4), heightEcran * 0.55)
        boite.put(choixExistant, (widthEcran *0.6), heightEcran * 0.4)
        boite.put(saisie, (widthEcran *0.2), heightEcran * 0.4)


        @win.show_all
        Gtk.main
    end

    ##
    # Charge les utilisateurs dans la combobox
    ##
    # * +combobox+  La combobox à remplir
    def chargerExistants(combobox)
        file = File.open($userPath + "users.txt")
        file_data = file.readlines.map(&:chomp)

        for i in file_data do
            combobox.append_text i
        end
        file.close
    end

    ##
    # Redirige vers le menu principal
    def vers_menu
        @win.set_title("FILL A PIX")
        @win.set_default_size(1200, 675)
        
        @win.remove(@layoutManager)

        Ecran_menu.creer(@win)
        return self
    end
end
