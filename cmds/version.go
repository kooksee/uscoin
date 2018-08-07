package cmds

import (
	"fmt"

	"github.com/spf13/cobra"

	tv "github.com/tendermint/tendermint/version"
	cv "github.com/cosmos/cosmos-sdk/version"
	"github.com/kooksee/usmint/version"
)

// VersionCmd ...
var VersionCmd = &cobra.Command{
	Use:   "version",
	Short: "Uscoin version info",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("tendermint version", tv.Version)
		fmt.Println("cosmos version", cv.GetVersion())
		fmt.Println("kchain version", version.Version)
		fmt.Println("kchain commit version", version.GitCommit)
		fmt.Println("kchain build version", version.BuildVersion)
	},
}
