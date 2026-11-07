import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Java Swing GUI Demo
 * Compile and run inside the Ubuntu GUI container:
 *   javac JavaGuiDemo.java
 *   java JavaGuiDemo
 */
public class JavaGuiDemo {
    private static int clickCount = 0;

    public static void main(String[] args) {
        // Run on the Event Dispatch Thread (EDT)
        SwingUtilities.invokeLater(() -> createAndShowGUI());
    }

    private static void createAndShowGUI() {
        // Set Look and Feel to System style
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {}

        JFrame frame = new JFrame("Java Swing GUI Demo - Ubuntu Desktop");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(520, 420);
        frame.setLocationRelativeTo(null);

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout(15, 15));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

        // Header Panel
        JPanel headerPanel = new JPanel(new GridLayout(2, 1, 5, 5));
        JLabel titleLabel = new JLabel("Java Swing GUI is Working!", JLabel.LEFT);
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, 18));
        titleLabel.setForeground(new Color(211, 47, 47));

        String javaVersion = System.getProperty("java.version");
        String javaVendor = System.getProperty("java.vendor");
        JLabel subtitleLabel = new JLabel("JDK Version: " + javaVersion + " (" + javaVendor + ")");
        subtitleLabel.setFont(new Font("SansSerif", Font.PLAIN, 12));

        headerPanel.add(titleLabel);
        headerPanel.add(subtitleLabel);
        mainPanel.add(headerPanel, BorderLayout.NORTH);

        // Center Panel: Info and interactive elements
        JPanel centerPanel = new JPanel();
        centerPanel.setLayout(new BoxLayout(centerPanel, BoxLayout.Y_AXIS));

        // Interactive counter panel
        JPanel counterPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        counterPanel.setBorder(BorderFactory.createTitledBorder("Interactive Test"));

        JLabel counterLabel = new JLabel("Button Click Count: 0");
        counterLabel.setFont(new Font("SansSerif", Font.PLAIN, 13));

        JButton clickButton = new JButton("Click Me!");
        clickButton.addActionListener(e -> {
            clickCount++;
            counterLabel.setText("Button Click Count: " + clickCount);
        });

        JButton resetButton = new JButton("Reset");
        resetButton.addActionListener(e -> {
            clickCount = 0;
            counterLabel.setText("Button Click Count: " + clickCount);
        });

        counterPanel.add(counterLabel);
        counterPanel.add(clickButton);
        counterPanel.add(resetButton);
        centerPanel.add(counterPanel);

        centerPanel.add(Box.createRigidArea(new Dimension(0, 10)));

        // Environment information panel
        JPanel infoPanel = new JPanel(new BorderLayout());
        infoPanel.setBorder(BorderFactory.createTitledBorder("Environment Details"));

        JTextArea infoText = new JTextArea();
        infoText.setEditable(false);
        infoText.setFont(new Font("Monospaced", Font.PLAIN, 12));
        infoText.setBackground(new Color(245, 245, 245));
        infoText.setText(
            "Java Home: " + System.getProperty("java.home") + "\n" +
            "OS:        " + System.getProperty("os.name") + " (" + System.getProperty("os.arch") + ")\n" +
            "User:      " + System.getProperty("user.name") + "\n" +
            "Display:   " + System.getenv("DISPLAY") + "\n"
        );
        infoPanel.add(new JScrollPane(infoText), BorderLayout.CENTER);
        centerPanel.add(infoPanel);

        mainPanel.add(centerPanel, BorderLayout.CENTER);

        // Footer Panel
        JPanel footerPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 0));
        JButton dialogButton = new JButton("Show Dialog");
        dialogButton.addActionListener(e -> {
            JOptionPane.showMessageDialog(frame,
                "Swing Dialogs & Java GUI apps work properly in this container!",
                "Java Swing Notification",
                JOptionPane.INFORMATION_MESSAGE);
        });

        JButton closeButton = new JButton("Close");
        closeButton.addActionListener(e -> frame.dispose());

        footerPanel.add(dialogButton);
        footerPanel.add(closeButton);
        mainPanel.add(footerPanel, BorderLayout.SOUTH);

        frame.setContentPane(mainPanel);
        frame.setVisible(true);
    }
}

